require 'rails_helper'

feature 'User can add links to question', "
  in order to provide additional info to my question
  as an question's author
  i'd like to be able to add links
" do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ivanprofpv/8ff9f7ff3c27dbac5ccec5cbc6aff558' }
  given(:two_url) { 'https://ya.ru' }
  given(:three_url) { 'https://ya.ru' }

  describe 'authenticated user can add links to their question', js: true do
    background do
      sign_in(user)

      visit new_question_path

      fill_in 'Title', with: 'title text'
      fill_in 'Body', with: 'body text'

      click_on 'Add link'

      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: two_url
    end

    scenario 'User adds link when asks question' do
      click_on 'Ask'

      expect(page).to have_link 'Yandex', href: two_url
    end

    scenario 'user can add 2 links to their question' do
      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex2'
        fill_in 'Url', with: three_url
      end

      click_on 'Ask'

      expect(page).to have_link 'Yandex', href: two_url
      expect(page).to have_link 'Yandex2', href: three_url
    end

    scenario 'user can delete links to their question' do
      click_on 'Ask'

      click_on 'Edit'

      click_on 'Delete link'

      expect(page).to_not have_link 'My gist', href: gist_url
    end

    scenario 'user adds link when editing' do
      click_on 'Ask'
      click_on 'Edit'
      within '.question-controls' do
        click_on 'Add link'

        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: two_url
      end

      click_on 'Save'
      sleep 2
      expect(page).to have_link 'Yandex', href: two_url
    end

    scenario 'user add gist link question' do
      fill_in 'Url', with: gist_url

      click_on 'Ask'
      sleep 2
      expect(page).to have_content 'gistfile1.txt'
      expect(page).to have_content 'hello world'
    end

  scenario 'user adds invalid links' do

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'http://ya. ru'

    click_on 'Ask'

    expect(page).to_not have_link 'My gist', href: 'http://ya. ru'
  end
  end
end
