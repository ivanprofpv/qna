FactoryBot.define do
  factory :oauth_application, class: 'DoorKeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '12345678' }
    secret { '123123123' }
  end
end