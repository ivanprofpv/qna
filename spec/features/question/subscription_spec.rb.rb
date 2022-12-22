require 'rails_helper'

feature 'The user can subscribe', "
  or unsubscribe from the question 
  and receive or refuse to receive notifications" 
  do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'create subscription after create question' do
      visit questions_path(question)
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'can subscribe to question' do
      visit questions_path
      click_on 'Subscribe'

      expect(page).to have_content 'Unsubscribe'
      expect(page).to has_no_content 'Subscribe'
    end
  end

  scenario 'Unauthenticated user tries to subscribe a question' do
    visit questions_path

    expect(page).to has_no_content 'Subscribe'
    expect(page).to has_no_content 'Unsubscribe'
  end
end
