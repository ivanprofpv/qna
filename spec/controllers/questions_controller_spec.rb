require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'fill in the array of all questions from the database' do
      # match_array helper that checks if something is equal to an array (see documentation)
      # assigns is also a helper that allows you to call
      # instance-variable from the controller for the test
      # questions in match_array here is taken from let above
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      # response - a helper that shows the last response in the controlle
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list :answer, 3, question: question, user: user}

    before { get :show, params: { id: question } } # we pass the question object, where the current id is substituted

    it 'check if the variable is set correctly in the controller (@question)' do
      expect(assigns(:question)).to eq question # is the instance variable equal to the question passed in the line above
    end

    it 'fill the array of @answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      before { login(user) }
      before { get :new }

      it 'check if the question is set to a variable (@question)' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'check if the question is set to a variable (@question)' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'unauthenticated user' do
      before { get :new }

      it 'redirect to log in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }
            .to change(Question, :count).by(1)
        end

        it 'redirect to show views' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the questions' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js }
            .to_not change(Question, :count)
        end

        it 'render template create' do
          post :create, params: { question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to_not change(Question, :count)
      end

      it 'redirect to sign in' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'check if the variable is set correctly in the controller (@question)' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change existing attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirect to update question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 're-render template update' do
          expect(response).to render_template :update
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not update question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'redirect to sign in' do
        patch :update, params: { id: question, question: attributes_for(:question) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before { login(user) }

      context 'delete a question that a user created' do
        let!(:question) { create(:question, user: user) }

        it 'delete the question' do
          expect { delete :destroy, params: { id: question, user: user } }.to change(Question, :count).by(-1)
        end

        it 'redirect to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_path
        end
      end

      context 'delete a question that the user did not create' do
        let!(:question) { create(:question, user: create(:user)) }

        it 'the question has not been deleted' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirect to root' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'unauthenticated user' do
      let!(:question) { create(:question, user: user) }

      it 'the question has not been deleted' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to sign in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
