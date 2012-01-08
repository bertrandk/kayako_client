require 'rexml/document'

module KayakoClient
    class REXMLDocument
        include KayakoClient::Logger
        include KayakoClient::XMLBackend

        def initialize(document, options = {})
            logger = options[:logger] if options[:logger]
            if (document.start_with?('<?xml '))
                @xml = REXML::Document.new(document)
            else
                start = document.index('<?xml version="1.0" encoding="UTF-8"?>')
                if start && start > 0
                    @notice = document.slice(0..start-1).gsub(%r{</?[A-Z0-9]+(?: +[A-Z]+="[^">]*")?>}i, '')
                    @xml = REXML::Document.new(document.slice(start..document.size))
                else
                    @error = document.gsub(%r{</?[A-Z0-9]+(?: +[A-Z]+="[^">]*")?>}i, '')
                end
            end
        rescue REXML::ParseException => error
            error.extend(::KayakoClient::XMLException)
            raise
        end

        def count
            if !error? && @xml.root
                @xml.root.elements.count
            else
                0
            end
        end

        def each(&block)
            @xml.root.elements.each(&block) if !error? && @xml.root
        end

        def to_hash(root = nil)
            hash = {}
            if !error? && @xml.root
                root ||= @xml.root
                root.attributes.each do |attribute, value|
                    hash[attribute.to_sym] = value
                end
                root.elements.each do |property|
                    name = property.name.to_sym
                    if property.has_elements? || property.has_attributes?
                        value = to_hash(property)
                        if property.has_text?
                            text = property.text.strip
                            unless text.empty?
                                value ||= {}
                                value[:contents] = text
                            end
                        end
                    elsif property.has_text?
                        value = property.text.strip
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
                if root.has_text?
                    text = root.text.strip
                    hash[:contents] = text unless text.empty?
                end
            end
            hash.empty? ? nil : hash
        end

    end
end
