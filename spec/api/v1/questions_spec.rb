require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'return status 200' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json.size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq questions.first.send(attr).as_json
        end
      end
    end
  end
end