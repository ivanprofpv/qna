# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'redirect to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
        end

        it 're-renders new views' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before { login(user) }

      context 'answer that the user created' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
        end
      end

      context 'answer that the user did not create' do
        let!(:answer) { create(:answer, question: question) }

        it 'unsuccessful attempt to delete someone another answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
        end

        it 'redirect to question' do
          delete :destroy, params: { id: answer, question_id: question }, format: :js
          expect(response).to redirect_to questions_path(assigns(:answer).question)
        end
      end
    end

    context 'unauthenticated user' do
      let!(:answer) { create(:answer, question: question) }

      it 'unsuccessful attempt to delete someone another answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end