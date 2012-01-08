require 'base64'

module KayakoClient
    module Object

        PROPERTY_TYPES = [ :integer,
                           :string,
                           :symbol,
                           :boolean,
                           :date,
                           :object,
                           :binary
                         ].freeze

        COMMON_OPTIONS = [ :in,
                           :required,
                           :condition,
                           :readonly,
                           :new
                         ].freeze

        OPTIONS        = { :integer => [ :range ],
                           :object  => [ :class ]
                         }.freeze

        def self.included(base)
            base.extend(ClassMethods)
        end

        def to_i
            instance_variable_defined?(:@id) ? instance_variable_get(:@id).to_i : 0
        end

        def []=(name, value)
            raise ArgumentError, "object properties are read-only" if self.class.embedded?
            raise ArgumentError, "property :#{name} does not exist" unless self.class.properties.include?(name.to_sym)
            if !self.class.options[name.to_sym] || !self.class.options[name.to_sym][:readonly]
                if self.class.options[name.to_sym] && self.class.options[name.to_sym][:new] && !new?
                    raise ArgumentError, "property :#{name} cannot be changed"
                end
                changes(name.to_sym)
                @associated.delete(name.to_sym)
                value = assign(self.class.properties[name.to_sym], value, self.class.options[name.to_sym] ? self.class.options[name.to_sym] : {})
                instance_variable_set("@#{name}", value)
            else
                raise ArgumentError, "property :#{name} is read-only"
            end
        end

        def [](name)
            if self.class.properties.include?(name.to_sym)
                send("#{name}")
            else
                nil
            end
        end

        def errors
            @errors ||= {}
        end

        def properties
            self.class.properties.keys
        end

        def changed?
            !changes.empty?
        end

        def new?
            if defined?(@new)
                @new
            else
                @new = true
            end
        end

        def has_errors?
            errors.size > 0
        end

        def loaded!
            @changes = []
            @new = false
        end

        module ClassMethods

            def embedded
                @embedded ||= true
            end

            def embedded?
                @embedded ||= false
            end

            def supports(*args)
                args.each do |method|
                    if %w{all get put post delete}.include?(method.to_s)
                        @supported_methods ||= []
                        @supported_methods << method.to_sym
                    else
                        logger.warn "ignored unsupported method :#{method}" if logger
                    end
                end
            end

            def support?(method)
                unless embedded?
                    defined?(@supported_methods) ? @supported_methods.include?(method) : true
                else
                    false
                end
            end

            def path(path = nil)
                if path
                    @path = path
                else
                    @path ||= '/' + self.superclass.name.split('::').last + '/' + self.name.split('::').last
                end
            end

            def property(name, type, options = {})
                if (type.is_a?(Array) && type.size == 1 && PROPERTY_TYPES.include?(type.first)) || PROPERTY_TYPES.include?(type)
                    init_variables
                    @properties[name] = type # save original type
                    type = type.first if type.is_a?(Array)
                    get_alias = options.delete(:get) if options[:get]
                    set_alias = options.delete(:set) if options[:set]
                    if (name.to_s.include?(?_))
                        altname = name.to_s.gsub(%r{_}, '')
                        get_alias = altname unless get_alias
                        set_alias = altname unless set_alias
                    end
                    # check options
                    options.each do |option, value|
                        if COMMON_OPTIONS.include?(option) || (OPTIONS.include?(type) && OPTIONS[type].include?(option))
                            @options[name] ||= {}
                            @options[name][option] = value
                        else
                            raise ArgumentError, "unsupported option: #{option}"
                        end
                    end
                    # check if :class was specified for :object
                    if type == :object
                        @options[name] ||= {}
                        @options[name][:readonly] = true
                        raise ArgumentError, ":object requires :class" unless @options[name][:class]
                    end
                    # define setter and getter methods
                    if !embedded? && (!@options[name] || !@options[name][:readonly])
                        define_method("#{name}=") do |value|
                            if self.class.options[name] && self.class.options[name][:new] && !new?
                                raise ArgumentError, "property :#{name} cannot be changed"
                            end
                            changes(name)
                            @associated.delete(name)
                            value = assign(self.class.properties[name], value, self.class.options[name] ? self.class.options[name] : {})
                            instance_variable_set("@#{name}", value)
                        end
                        if set_alias
                            alias_method("#{set_alias}=", "#{name}=")
                            @map[name] = set_alias.to_sym
                        end
                    end
                    define_method(name) do
                        instance_variable_defined?("@#{name}") ? instance_variable_get("@#{name}") : nil
                    end
                    alias_method("#{name}?", name) if type == :boolean
                    if get_alias
                        alias_method(get_alias, name)
                        @aliases[get_alias.to_sym] = name
                    end
                else
                    raise ArgumentError, "unsupported type: #{type.inspect}"
                end
            end

            def associate(name, property, object)
                unless @properties.include?(property)
                    raise ArgumentError, "undefined property: #{property}; use 'property :#{property} ...' first"
                end
                klass = object.is_a?(Class) ? object : KayakoClient.const_get(object)
                # method for access to associated object
                define_method(name) do
                    if @associated.has_key?(property)
                        @associated[property]
                    elsif instance_variable_defined?("@#{property}")
                        id = instance_variable_get("@#{property}")
                        if id.is_a?(Array)
                            @associated[property] = id.inject([]) do |array, i|
                                array << klass.get(i.to_i, inherited_options)
                                array
                            end
                        elsif id.respond_to?('to_i') && id.to_i > 0
                            @associated[property] = klass.get(id.to_i, inherited_options)
                        else
                            @associated[property] = nil
                        end
                    else
                        @associated[property] = nil
                    end
                end
            end

            def check_conditions(params)
                errors = params.delete(:errors)
                return unless errors
                options.each do |property, option|
                    if params[property]
                        if option[:condition] && option[:condition].is_a?(Hash)
                            option[:condition].each do |name, value|
                                errors[property] = "condition not met" unless params[name] == value
                            end
                        end
                    end
                end
            end

            def require_properties(method, params)
                options.each do |property, option|
                    next if params[property]
                    if option[:required]
                        if (option[:required].is_a?(Symbol) && option[:required] == method) ||
                            (option[:required].is_a?(Array) && option[:required].include?(method))
                            raise ArgumentError, "missing :#{property}"
                        end
                    end
                end
            end

            def validate(params)
                errors = params.delete(:errors)
                params.inject({}) do |hash, (property, value)|
                    if properties.include?(property)
                        begin
                            name = map[property] ? map[property] : property
                            hash[name] = convert(properties[property], value, options[property] ? options[property] : {})
                        rescue => error
                            errors[property] = error.message if errors
                        end
                    else
                        logger.warn "skipping validation of unknown property: #{property}" if logger
                    end
                    hash
                end
            end

            def convert(type, value, options = {})
                raise "property is readonly" if options[:readonly]
                if type.is_a?(Array)
                    type = type.first
                    if value.is_a?(Hash) && value.size == 1
                        value = value.values.first
                    end
                    value = [ value ] unless value.is_a?(Array)
                    value.map! do |item|
                        convert_value(type, item, options)
                    end
                else
                    value = convert_value(type, value, options)
                end
                value
            end

            def convert_value(type, value, options = {})
                if options[:in] && options[:in].is_a?(Array)
                    raise "not in list of allowed values" unless options[:in].include?(value)
                end
                case type
                when :integer
                    if options[:range] && options[:range].is_a?(Range)
                        raise "out of range" unless options[:range].include?(value)
                    end
                    result = value
                when :symbol
                    result = value.to_s
                when :boolean
                    result = (value == true) ? 1 : 0
                when :date
                    result = value ? value.to_i : 0
                when :object
                    raise RuntimeError, ":object cannot be used as a parameter"
                when :binary
                    result = Base64.encode64(value).strip
                else
                    result = value
                end
                result
            end

            def properties
                @properties
            end

            def aliases
                @aliases
            end

            def options
                @options
            end

            def map
                @map
            end

        private

            def init_variables
                @properties ||= {}
                @aliases ||= {}
                @options ||= {}
                @map ||= {}
            end

        end

    private

        def clean
            @associated = {}
            self.class.properties.each do |property, type|
                if instance_variable_defined?("@#{property}")
                    remove_instance_variable("@#{property}")
                end
            end
        end

        def import(options = {})
            if options.size == 1 && self.class.properties.size > 1
                values = options.values.first
                options = values if values.is_a?(Hash)
            end
            return if options.empty?
            options.each do |property, value|
                name = self.class.aliases.include?(property) ? self.class.aliases[property] : property
                if self.class.properties.include?(name)
                    unless self.class.embedded? || (self.class.options[name] && self.class.options[name][:readonly])
                        changes(name)
                    end
                    value = assign(self.class.properties[name], value, self.class.options[name] ? self.class.options[name] : {})
                    instance_variable_set("@#{name}", value)
                else
                    logger.debug "unsupported property :#{property}" if logger
                end
            end
        end

        def validate(method, params)
        end

        def check_conditions(params)
            @errors ||= {}
            self.class.options.each do |property, options|
                # check :condition
                if params[property]
                    if options[:condition] && options[:condition].is_a?(Hash)
                        options[:condition].each do |name, value|
                            param = params[name] || (instance_variable_defined?("@#{name}") ? instance_variable_get("@#{name}") : nil)
                            @errors[property] = "condition not met" unless param == value
                        end
                    end
                end
                # check :new
                if params.has_key?(property)
                    @errors[property] = "value cannot be changed" if options[:new] && !new?
                end
            end
        end

        def require_properties(method, params)
            self.class.options.each do |property, options|
                next if params[property]
                if options[:required]
                    if (options[:required].is_a?(Symbol) && options[:required] == method) ||
                        (options[:required].is_a?(Array) && options[:required].include?(method))
                        params[property] = instance_variable_get("@#{property}") if instance_variable_defined?("@#{property}")
                        raise ArgumentError, "missing :#{property}" if params[property].nil?
                    end
                end
            end
        end

        def changes(property = nil)
            @changes ||= []
            unless property.nil?
                @changes << property unless @changes.include?(property)
            end
            @changes
        end

        def assign(type, value, options = {})
            if type.is_a?(Array)
                type = type.first
                if value.is_a?(Hash) && value.size == 1
                    value = value.values.first
                end
                value = [ value ] unless value.is_a?(Array)
                value.map! do |item|
                    assign_value(type, item, options)
                end
                value.freeze if options[:readonly]
            else
                value = assign_value(type, value, options)
            end
            value
        end

        def assign_value(type, value, options = {})
            case type
            when :integer
                value.to_i
            when :string
                value.to_s
            when :symbol
                value.to_sym
            when :boolean
                if value.respond_to?('to_i')
                    value.to_i == 0 ? false : true
                else
                    case value
                    when TrueClass, FalseClass
                        value
                    else
                        !!value
                    end
                end
            when :date
                case value
                when Time
                    value
                else
                    value.to_i > 0 ? Time.at(value.to_i) : nil
                end
            when :object
                raise RuntimeError, "missing :class" unless options[:class]
                klass = options[:class].is_a?(Class) ? options[:class] : KayakoClient.const_get(options[:class])
                object = klass.new(value.merge(inherited_options))
                object.loaded!
                object
            when :binary
                if value =~ %r{^[A-Za-z0-9+/]+={0,3}$} && (value.size % 4) == 0
                    logger.debug "decoding base64 string" if logger
                    Base64.decode64(value)
                else
                    value
                end
            else
                value
            end
        end

    end
end
