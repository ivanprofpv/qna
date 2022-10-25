require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'check if the variable is set correctly in the controller (@answer)' do
      expect(assigns(:answer)).to eq answer #is the instance variable equal to the answer passed in the line above
    end

    it 'render show view' do     
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new, params: { question_id: question } }

    it 'check if the question is set to a variable @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: { id: answer } }

    it 'check if the variable is set correctly in the controller (@answer)' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: { body: "body" } } }.to change(question.answers, :count).by(1)
      end
      it 'redirect to show views' do
        post :create, params: { question_id: question, answer: { body: "body" } }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-renders new views' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'check if the variable is set correctly in the controller(@answer)' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'изменяем существующие атрибуты' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirect to update question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    
    it 'delete the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to answer' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to questions_path(answer.question)
    end
  end

end