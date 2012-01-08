module KayakoClient
    module Logger

        def self.included(base)
            base.extend(ClassMethods)
        end

        def logger=(log)
            @logger = log
        end

        def logger
            @logger ||= self.class.logger
        end

        module ClassMethods

            def logger=(log)
                @@logger = log
            end

            def logger
                @@logger ||= nil
            end

        end

    end
end
