require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:question) { create(:question, title: 'test') }
  let(:service) { SearchService.new('test', 'Question') }

  describe 'GET #index' do
    before do
      allow(SearchService).to receive(:new).with('test', 'Question').and_return(service)
      allow(service).to receive(:call).and_return([question])
      get :index, params: { query: 'test', scope: 'Question' }
    end

    it 'assigns @search_result' do
      expect(assigns(:search_result)).to eq([question])
    end

    it 'renders index' do
      expect(response).to render_template :index
    end
  end
end
