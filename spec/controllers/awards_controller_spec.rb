require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }
  let(:award) { create(:award, user_id: user.id) }

  describe 'GET #index' do

    context 'authenticated user' do
      it 'filling the array of awards' do
        login(user)
        get :index

        expect(assigns(:user_awards)).to match_array(user.awards)
      end

      it 'render index view' do
        login(user)
        get :index
        expect(response).to render_template :index
      end
    end

    context 'unauthenticated user' do
      it 'redirect to sign in' do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
