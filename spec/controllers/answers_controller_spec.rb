# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

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

  describe 'PATCH #update' do

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        context "with user's answer" do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(response).to render_template :update
          end

          it "is answer user's" do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(assigns(:answer).user).to eq user
          end
        end

        context "with other's answers" do
          let(:answer) { create(:answer, question: question, user: create(:user)) }

          it 'not changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to_not eq 'new body'
          end

          it 'renders question ' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(response).to redirect_to question_path(assigns(:answer).question)
          end

          it "is not answers user's" do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(assigns(:answer).user).to_not eq user
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not changes answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'unauthenticated user' do
      context 'with valid attributes' do
        it 'does not change attributes' do
          expect do
            patch :update, params: { id: answer, answer: answer }, format: :js
          end.to_not change(answer, :body)
        end

        it 'redirect to sign in page' do
          patch :update, params: { id: answer, answer: answer }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'does not change attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'redirect to sign in page' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'PATCH #best' do
    context 'Author of the question' do
      before { login user }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'marks the answer as the best' do 
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'render best template' do 
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'not the author of the question' do 
      before { login create(:user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'can not marks the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end

      it 'render best template' do 
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before { login(user) }

      context 'answer that the user created' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
        end
      end

      context 'answer that the user did not create' do
        let!(:answer) { create(:answer, question: question) }

        it 'unsuccessful attempt to delete someone another answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
        end

        it 'redirect to question' do
          delete :destroy, params: { id: answer, question_id: question }
          expect(response).to redirect_to question_path
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
