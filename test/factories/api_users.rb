# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :api_user do
    email "test@user.com"
    full_name "Test User"
    company "Test Company"
    reason "To test things"
    permissions({"ProtectedArea" => ["name", "marine"]})

    token "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  end
end

