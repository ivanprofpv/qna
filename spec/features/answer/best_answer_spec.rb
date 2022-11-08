require 'rails_helper'

feature 'User can choose the best answer' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  describe 'authenticated user', js: true do
    scenario 'can choose the best answer in your question' do
      sign_in user
      visit question_path(question)

      within ".answer-id-#{answers.first.id}" do
        click_on 'Best answer'

        expect(page).to have_content answers.first.body
        expect(page).to_not have_link 'Best answer'
      end
    end

    scenario 'can not choose the best answer not in your question' do
      sign_in other_user
      visit question_path(question)

      within ".answer-id-#{answers.first.id}" do
        expect(page).to_not have_link 'Best answer'
      end
    end
  end

  describe 'unauthenticated user', js: true do
    scenario 'can not choose the best answer' do
      visit question_path(question)
      expect(page).to_not have_link 'Best answer'
    end
  end
end
