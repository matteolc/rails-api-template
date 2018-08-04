FactoryBot.define do
    factory :user do
        username { 'example' }
        email { 'example@domain.com' }
        password { '12345678' }
    end    
end