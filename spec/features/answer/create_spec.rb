require 'rails_helper'

feature 'The user can write the answer in the question' do 
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user' do 
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write the answer in the question' do 
      fill_in 'Body', with: 'text body'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answer_container' do 
        expect(page).to have_content 'text body'
      end
    end

    scenario 'empty answer' do 
      click_on 'Reply'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'unauthenticated user' do

    scenario "can't write an answer" do 
      visit question_path(question)
      expect(page).to_not have_button 'Reply'
    end
  end

end