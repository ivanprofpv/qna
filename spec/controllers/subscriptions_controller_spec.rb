require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do

      it 'create and save subscribe' do
        login(user)

        expect do
          post :create, params: { question_id: question },
                format: :js
        end.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'unauthenticated user' do

      it 'does not create and save subscribe' do
        expect do
          post :create, params: { question_id: question },
                format: :js
        end.to change(question.subscriptions, :count).by(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, user_id: user.id }

    context 'authenticated user' do
      before { login(user) }

      it 'delete subscribe' do
        expect do
          post :destroy, params: { id: question.subscriptions.first },
                format: :js
        end.to change(question.subscriptions, :count).by(0)
      end

      it 'return successfull delete' do
        post :destroy, params: { id: subscription }, format: :js
        expect(response).to redirect_to root_path
      end

      context 'user can not delete other user subscribtion'
        let(:other_user) { create(:user) }

        before { login(other_user) }

        it 'does not delete subscribe' do
          expect do
            post :destroy, params: { id: question.subscriptions.first }, format: :js
          end.to_not change(question.subscriptions, :count)
        end

        it 'return 302 status' do
          post :destroy, params: { id: question.subscriptions.first }, format: :js
          expect(response.status).to eq 302
        end
    end

    context 'unauthenticated user' do

      it 'does not delete subscribe' do
        expect do
          post :destroy,
               params: { id: subscription },
               format: :js
        end.to_not change(question.subscriptions, :count)
      end

      it 'redirect to sign in' do
        post :destroy, params: { id: subscription }, format: :js
        expect(response).to be_unauthorized
      end
    end
  end
end
