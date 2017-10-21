class Api::V1::PostResource < Api::V1::ApiResource
    
    attributes  :title, 
                :body,
                :author_id,
                :published_at,
                :likes,
                :published,
                :category

    has_one :author
    filters :title, :published, :category, :author_id

end
