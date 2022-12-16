require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 5, question: question, user: user) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return status 200' do
        expect(response).to be_successful
      end

      it 'return answers list' do
        expect(json['answers'].size).to eq 5
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 2, linkable: answer) }

      before do
        answer.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb')
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq(answer.send(attr).as_json)
        end
      end

      it 'contains comments list' do
        expect(json['answer']['comments'].size).to eq 2
      end

      it 'contains links list' do
        expect(json['answer']['links'].size).to eq 2
      end

      it 'contains attachments url list' do
        attachments_url = Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)

        expect(json['answer']['files'].first['url']).to eq attachments_url 
      end
    end
  end
end