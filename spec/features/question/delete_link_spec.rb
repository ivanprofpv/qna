require 'rails_helper'

feature 'user can delete links in their questions' do
  given(:user) { create(:user) }
  given(:two_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:link) { 'https://ya.ru' }

  describe 'authenticated user', js: true do
    scenario 'can delete link to question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Add link'

      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: link

      click_on 'Create Answer'

      click_on 'Delete link'
      expect(page).to_not have_link 'Yandex', href: link
    end

    scenario 'does not see the delete link to question' do
      sign_in(two_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'unauthenticated user' do

    scenario 'does not see the delete link to question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
