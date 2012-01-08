module KayakoClient
    module XML

        def self.included(base)
            base.extend(ClassMethods)
        end

        def xml_backend=(backend)
            if backend.is_a?(String)
                raise ArgumentError, "invalid XML backend: #{backend}" unless backend =~ /^[A-Za-z_]+$/
                file = backend.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/([A-Z])([A-Z][a-z])/, '\1_\2').downcase
                require "kayako_client/xml/#{file}"
                backend = KayakoClient.const_get(backend)
            end
            if backend.is_a?(Class)
                if backend.included_modules.include?(KayakoClient::XMLBackend)
                    @xml_backend = backend
                else
                    raise ArgumentError, "invalid XML backend: #{backend.name}"
                end
            else
                raise ArgumentError, "unsupported XML backend"
            end
        end

        def xml_backend
            @xml_backend ||= self.class.xml_backend
        end

        module ClassMethods

            def xml_backend=(backend)
                if backend.is_a?(String)
                    raise ArgumentError, "invalid XML backend: #{backend}" unless backend =~ /^[A-Za-z_]+$/
                    file = backend.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/([A-Z])([A-Z][a-z])/, '\1_\2').downcase
                    require "kayako_client/xml/#{file}"
                    backend = KayakoClient.const_get(backend)
                end
                if backend.is_a?(Class)
                    if backend.included_modules.include?(KayakoClient::XMLBackend)
                        @@xml_backend = backend
                    else
                        raise ArgumentError, "invalid XML backend: #{backend.name}"
                    end
                else
                    raise ArgumentError, "unsupported XML backend"
                end
            end

            def xml_backend
                begin
                    require 'kayako_client/xml/lib_xml'
                    @@xml_backend ||= KayakoClient::LibXML
                rescue LoadError
                    require 'kayako_client/xml/rexml_document'
                    @@xml_backend ||= KayakoClient::REXMLDocument
                end
            end

        end

    end
end
