require 'rails_helper'

feature 'user can delete their questions' do
  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 2) }

  describe 'authenticated user' do
    background { sign_in(questions[0].user) }

    scenario 'can delete their questions' do
      visit question_path(questions[0])
      expect(page).to have_content questions[0].body

      click_on 'Delete question'

      expect(page).to have_content 'Question successfully deleted!'
      expect(page).to_not have_content questions[0].body
    end

    scenario 'user cannot delete other user questions' do
      visit question_path(questions[1])

      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'unauthenticated user' do
    scenario "can't delete questions" do
      visit question_path(questions[0])

      expect(page).to_not have_content 'Delete question'
    end
  end
end
