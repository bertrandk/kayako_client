module KayakoClient

    module XMLBackend

        def initialize(document)
            raise NotImplementedError, "not implemented"
        end

        def count
            raise NotImplementedError, "not implemented"
        end

        def each(&block)
            raise NotImplementedError, "not implemented"
        end

        def to_hash(root = nil)
            raise NotImplementedError, "not implemented"
        end

        def notice?
            defined?(@notice)
        end

        def error?
            defined?(@error)
        end

        def notice
            @notice || nil
        end

        def error
            @error || nil
        end

    end

    module XMLException
    end

end
