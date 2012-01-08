require 'libxml'

module KayakoClient

    class LibXML
        include KayakoClient::Logger
        include KayakoClient::XMLBackend

        def initialize(document, options = {})
            logger = options[:logger] if options[:logger]
            if (document.start_with?('<?xml '))
                @xml = ::LibXML::XML::Parser.string(document).parse
            else
                start = document.index('<?xml version="1.0" encoding="UTF-8"?>')
                if start && start > 0
                    @notice = document.slice(0..start-1).gsub(%r{</?[A-Z0-9]+(?: +[A-Z]+="[^">]*")?>}i, '')
                    @xml = ::LibXML::XML::Parser.string(document.slice(start..document.size)).parse
                else
                    @error = document.gsub(%r{</?[A-Z0-9]+(?: +[A-Z]+="[^">]*")?>}i, '')
                end
            end
        rescue ::LibXML::XML::Parser::ParseError => error
            error.extend(::KayakoClient::XMLException)
            raise
        end

        def count
            if !error? && @xml.root
                @xml.root.children.inject(0) do |count, node|
                    count += 1 if node.element?
                    count
                end
            else
                0
            end
        end

        def each(&block)
            @xml.root.each_element(&block) if !error? && @xml.root
        end

        def to_hash(root = nil)
            hash = {}
            if !error? && @xml.root
                root ||= @xml.root
                root.each_attr do |attribute|
                    hash[attribute.name.to_sym] = attribute.value
                end
                root.each_element do |property|
                    name = property.name.to_sym
                    elements = property.children.inject(0) do |count, node|
                        count += 1 if node.element?
                        count
                    end
                    if elements > 0 || property.attributes?
                        value = to_hash(property)
                        if property.children.size == 1 && (property.first.text? || property.first.cdata?)
                            text = property.content.strip
                            unless text.empty?
                                value ||= {}
                                value[:contents] = text
                            end
                        end
                    elsif property.children.size == 1 && (property.first.text? || property.first.cdata?)
                        value = property.content.strip
                    end
                    unless value.nil? || value.empty?
                        if hash.include?(name)
                            hash[name] = [ hash[name] ] unless hash[name].is_a?(Array)
                            hash[name].push(value)
                        else
                            hash[name] = value
                        end
                    end
                end
                if root.children.size == 1 && (root.first.text? || root.first.cdata?)
                    text = root.content.strip
                    hash[:contents] = text unless text.empty?
                end
            end
            hash.empty? ? nil : hash
        end

    end

end
