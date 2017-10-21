class Api::V1::AuthorResource < Api::V1::ApiResource    

        attributes  :name    

        has_many :posts
        
        filters :name        
end