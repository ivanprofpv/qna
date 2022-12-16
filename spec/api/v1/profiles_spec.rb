require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API authorizable'

    context 'when authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get(api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns all users except resource owner' do
        expect(json['users'].size).to eq 2
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end