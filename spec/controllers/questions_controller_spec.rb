require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'заполнить массив всех вопросов из базы' do
      #match_array хелпер, который проверяет, что что-то равно массиву (см документацию)
      #assigns тоже хелпер, который позволяет вызвать
      #инстанс-переменную из контроллера для теста
      #questions в match_array здесь берется из let выше
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      #response - хелпер, который показывает ответ, который был последним в контроллере
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } } #передаем объект вопроса, где подставляется текущий id

    it 'устанавливаем переменную в объект (@question), который запросили' do
      expect(assigns(:question)).to eq question #равна ли инстанс-переменная вопросу, который передали в строке выше
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new }

    it 'проверяем, устанавливается ли вопрос в переменную @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: { id: question } }

    it 'устанавливаем переменную в объект (@question), который запросили' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirect to show views' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the questions' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new views' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'устанавливаем переменную в объект (@question), который запросили' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'изменяем существующие атрибуты' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to update question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with valid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render update view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    
    it 'delete the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
