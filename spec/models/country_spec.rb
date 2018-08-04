require "rails_helper"

RSpec.describe Country, type: :model do

    describe "Basic features" do
       
        it "is valid with valid attributes" do
            country = create(:country)
            expect(country).to be_valid
        end

        it "is not valid without an alpha3" do
            country = build(:country, alpha3: nil)
            expect(country).to_not be_valid
        end

    end

end