require 'rails_helper'

feature 'user can delete links in their answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:link) { create(:link, name: 'Yandex', url: 'https://ya.ru', linkable: answer) }

  describe 'authenticated user', js: true do
    scenario 'can delete link' do
      sign_in(user)
      visit question_path(question)

      click_on 'delete link'
      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
