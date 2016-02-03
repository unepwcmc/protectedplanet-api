# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_user do
    email "test@user.com"
    full_name "Test User"
    company "Test Company"
    reason "To test things"

    token "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  end
end

