require 'rails_helper'

describe 'Questions API', type: :request do
    let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return status 200' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:access_token) {create(:access_token)}
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    before do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
    end

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before {get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'contains comments list' do
        expect(json['question']['comments'].size).to eq 2
      end

      it 'contains links list' do
        expect(json['question']['links'].size).to eq 2
      end

      it 'contains attachments url list' do
        attachments_url = Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true)

        expect(json['question']['files'].first['url']).to eq attachments_url
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'with valid attributes' do
      let(:access_token) {create(:access_token)}

      it 'create new question and save' do
        expect do
          post(api_path,
               params: {
               access_token: access_token.token, question: attributes_for(:question) },
               headers: headers)

        end.to change(Question, :count).by(1)
      end

      it 'returns 201 status' do
        post(api_path,
             params: { access_token: access_token.token, question: attributes_for(:question) },
             headers: headers)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      before do
        post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
      end

      it 'does not save new question' do
        expect do
          post(api_path,
               params: {
               access_token: access_token.token, question: attributes_for(:question, :invalid) },
               headers: headers)

        end.to_not change(Question, :count)
      end

      it 'returns 422 status' do
        post(api_path,
             params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
             headers: headers)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch(api_path,
                params: { id: question,
                          question: { title: 'MyString2', body: 'MyText2' },
                          access_token: access_token.token })
        end

        it 'update question' do
          question.reload

          expect(question.title).to eq 'MyString2'
          expect(question.body).to eq 'MyText2'
        end

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch(api_path,
                params: { id: question,
                          question: { title: '', body: '' },
                          access_token: access_token.token })
        end

        it 'does not update question' do
          question.reload

          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end

    context 'other user update question' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

      before do
        patch(other_api_path,
              params: { id: other_question,
                        question: { title: 'new title', body: 'new_body' },
                        access_token: access_token.token })
      end

      it 'returns 302 status' do
        expect(response.status).to eq 302
      end

      it 'does not update question' do
        other_question.reload

        expect(other_question.title).to eq other_question.title
        expect(other_question.body).to eq other_question.body
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    before do
      delete(api_path,
             params: { id: question, access_token: access_token.token },
             headers: headers)
    end

    it 'delete quesion' do
      expect(Question.count).to eq 0
    end
  end
end
