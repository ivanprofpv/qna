require 'rails_helper'

feature 'User can delete their answer' do 

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do 

    scenario 'can delete their answer' do 
      sign_in(user)
      visit root_path

      click_on question.title
      click_on 'Delete answer'

      expect(page).to have_content 'Answer successfully deleted!'
      expect(page).to_not have_content answer.body
    end

    scenario "user can't delete another user's answer" do 
    	sign_in(other_user)
    	visit root_path

    	click_on question.title

    	expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'unauthenticated user' do 

    scenario "can't delete answer" do 
    	visit root_path

    	click_on question.title

    	expect(page).to_not have_content 'Delete answer'
    end
  end
end