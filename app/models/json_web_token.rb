class JsonWebToken
    
    attr_reader :algorithm, :secret

    def initialize(algorithm = 'HS256', secret = ENV['JWT_SECRET'])
        @algorithm = algorithm
        @secret = secret
    end

    def encode(payload)
        JWT.encode(payload, secret, algorithm)
    end

    def decode(token)
        return HashWithIndifferentAccess.new(JWT.decode(token, secret, true, {:algorithm => algorithm})[0])
    end

end