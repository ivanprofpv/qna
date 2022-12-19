require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question, user: user) }

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
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question, user: user) }
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

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    answer: { body: 'body' },
                                    access_token: access_token.token }
        end

        it 'changes answer' do
          answer.reload

          expect(answer.body).to eq 'body'
        end

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    answer: { body: '' },
                                    access_token: access_token.token }
        end

        it 'does not change attributes of question' do
          answer.reload

          expect(answer.body).to_not eq 'new body'
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    before do
      delete api_path, params: { id: answer, access_token: access_token.token }, headers: headers
    end

    it 'delete answer' do
      expect(Answer.count).to eq 0
    end
  end

  describe 'POST /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          post api_path, params: { question_id: question, answer: { body: 'body' },
                                    access_token: access_token.token }
        end

        it 'save new answer' do
          expect(Answer.count).to eq 1
        end

        it 'returns status 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        before do
          post api_path, params: { question_id: question, answer: { body: '' },
                                    access_token: access_token.token }
        end

        it 'not save answer' do
          expect(Answer.count).to eq 0
        end

        it 'returns status 422' do
          expect(response).to have_http_status 422
        end
      end
    end
  end
end