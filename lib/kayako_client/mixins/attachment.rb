require 'tempfile'

module KayakoClient
    module Attachment

        def initialize(*args)
            if args.last.is_a?(Hash) && args.last[:file]
                self.file = args.last.delete(:file)
            end
            super(*args)
        end

        def file=(arg)
            unless self.class.properties[:contents] && self.class.properties[:file_name]
                raise RuntimeError, "missing :contents and/or :file_name properties"
            end
            raise ArgumentError, "object properties are read-only" if self.class.embedded?
            if self.class.options[:contents] && self.class.options[:contents][:readonly]
                raise ArgumentError, "property :contents is read-only"
            end
            if self.class.options[:contents] && self.class.options[:contents][:new] && !new?
                raise ArgumentError, "property :contents cannot be changed"
            end
            case arg
            when File, Tempfile
                arg.rewind
                arg.binmode
                @contents = arg.read
            when String
                raise ArgumentError, "file path can't be empty" if arg.empty?
                @contents = File.open(arg, 'rb') do |f|
                    f.read
                end
            else
                raise ArgumentError, "invalid argument must be either File or path"
            end
            changes(:contents)
            if !self.class.options[:file_name] ||
                (!self.class.options[:contents][:readonly] && (!self.class.options[:contents][:new] || new?))
                case arg
                when File
                    @file_name = File.basename(arg.path)
                when String
                    @file_name = File.basename(arg)
                end
                changes(:file_name)
            end
        end

        def file
            unless self.class.properties[:contents] && self.class.properties[:file_name]
                raise RuntimeError, "missing :contents and/or :file_name properties"
            end
            if defined?(@file)
                @file
            elsif contents
                raise RuntimeError, "not a remote file" unless id && !new?
                @file = Tempfile.new([file_name.split('.').first || 'kayako_attachment', "."+file_name.split('.').last])
                @file.binmode
                @file.write(contents)
                @file.flush
                @file.rewind
                @file
            else
                nil
            end
        end

    end
end
