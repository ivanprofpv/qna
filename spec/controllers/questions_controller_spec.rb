require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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

end
