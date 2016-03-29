FactoryGirl.define do
  factory :bank_transaction do
    account_id 'test-account'
    sequence(:fit_id)
    amount 9.99
    posted_at '2000-01-01'
  end
end
