require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

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

      # describe 'answers' do
      #   let(:answer) { answers.first }
      #   let(:answer_response) { question_response['answers'].first }

      #   it 'return list of answers' do
      #     expect(question_response['answers'].size).to eq 3
      #   end

      #   it 'return all public fields' do
      #     %w[id body user_id created_at updated_at].each do |attr|
      #       expect(answer_response[attr]).to eq answer.send(attr).as_json
      #     end
      #   end
      # end
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
end