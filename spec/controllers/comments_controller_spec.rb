require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'save question comment' do
        expect do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment) },
                                  format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'save answer comment' do
        expect do
          post :create, params: { answer_id: answer,
                                  comment: attributes_for(:comment) },
                                  format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'render create' do
        post :create, params: { answer_id: answer,
                                  comment: attributes_for(:comment) },
                                  format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'save question comment' do
        expect do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment, :invalid) },
                                  format: :js
        end.not_to change(Comment, :count)
      end

      it 'render create' do
        post :create, params: { answer_id: answer,
                                  comment: attributes_for(:comment, :invalid) },
                                  format: :js

        expect(response).to render_template :create
      end
    end

    context 'unauthenticated user can add comment' do
      it 'does not save answer' do
        expect do
          post :create, params: { answer_id: answer,
                                  comment: attributes_for(:comment) },
                                  format: :js

        end.not_to change(Comment, :count)
      end
    end
  end
end
