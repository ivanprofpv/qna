require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:attachment) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

    context 'authenticated user' do
      before { login user }

      context 'the author uploaded the attachment' do
        let!(:author_attachment) { create(:question, user: user, files: [attachment]) }

        it 'can remove attachment' do
          expect do
            delete :destroy, params: { id: author_attachment.files.first },
                             format: :js
          end.to change(author_attachment.files, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: author_attachment.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'attachment owner another author' do
        let!(:author_attachment) { create(:question, user: other_user, files: [attachment]) }

        it 'can not remove attachment' do
          expect do
            delete :destroy, params: { id: author_attachment.files.first },
                             format: :js
          end.to_not change(author_attachment.files, :count)
        end

        it 'no render destroy' do
          delete :destroy, params: { id: author_attachment.files.first }, format: :js
          expect(response).not_to render_template :destroy
        end
      end
    end

    context 'unuthenticated user' do
      let!(:author_attachment) { create(:question, user: user, files: [attachment]) }

      it 'can not remove attachment' do
        expect do
          delete :destroy, params: { id: author_attachment.files.first },
                           format: :js
        end.to_not change(author_attachment.files, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: author_attachment.files.first }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
