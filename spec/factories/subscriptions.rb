FactoryBot.define do
  factory :subscription do
    plan_id { "MyString" }
    customer_id { "MyString" }
    user { nil }
    status { "MyString" }
    current_period_end { "2023-04-30 17:51:34" }
    current_period_start { "2023-04-30 17:51:34" }
    interval { "MyString" }
    subscription_id { "MyString" }
  end
end
