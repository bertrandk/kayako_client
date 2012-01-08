require 'base64'

module KayakoClient
    module Authentication

        def self.included(base)
            base.extend(ClassMethods)
        end

        module ClassMethods

            def salt(count = 32)
                pass = ''
                chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
                count.times do |i|
                    pass << chars[rand(chars.size - 1)]
                end
                pass
            end

            def signature(salt, secret = nil)
                begin
                    require 'openssl'
                    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, secret || secret_key, salt)
                rescue LoadError, NameError
                    hash = HMAC::sha256(secret || secret_key, salt)
                end
                Base64.encode64(hash).strip
            end

        end

    end
end
