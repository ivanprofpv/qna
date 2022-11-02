require 'rails_helper'

feature 'User can edit his answer', %q{
  in order to correct mistakes
  as an author of answer
  i'd like ot be  able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'unauthenticated user' do

    scenario "can't write an answer" do
      visit question_path(question)
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit his answer' do
      click_on 'Edit answer'

      within '.answers' do 
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edit answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors'

    scenario "tries to edit other user's question"
  end

end
