require 'rails_helper'

feature 'User can add links to answer', "
  in order to provide additional info to my answer
  as an question's author
  i'd like to be able to add links
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ivanprofpv/8ff9f7ff3c27dbac5ccec5cbc6aff558' }
  given(:two_url) { 'https://ya.ru' }
  given(:three_url) { 'https://ya.ru' }

  describe 'authenticated user can add links to their answer', js: true do
    background do
      sign_in(user)

      visit question_path(question)

      fill_in 'Your answer', with: 'My answer'

      click_on 'Add link'

      fill_in 'Link name', with: 'Yandex2'
      fill_in 'Url', with: three_url
    end

    scenario 'User adds link when give an answer' do
      click_on 'Create Answer'

      within '.answer_block' do
        expect(page).to have_link 'Yandex', href: two_url
      end
    end

    scenario 'user can add 2 links to their answer' do
      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: two_url
      end

      click_on 'Create Answer'

      expect(page).to have_link 'Yandex2', href: three_url
      expect(page).to have_link 'Yandex', href: two_url
    end

    scenario 'user can delete links to their answer' do
      click_on 'Create Answer'

      click_on 'Edit'

      within '.answer_block' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link 'Yandex2', href: three_url
    end

    scenario 'user adds link when editing answer' do
      click_on 'Create Answer'

      click_on 'Edit'
      
      within '.answer_block' do
        click_on 'Add link'
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: two_url
      end

      click_on 'Save'

      expect(page).to have_link 'Yandex', href: two_url
    end

    scenario 'user add gist link answer' do
      
      fill_in 'Url', with: gist_url

      click_on 'Create Answer'

      expect(page).to have_content 'gistfile1.txt'
      expect(page).to have_content 'hello world'
    end

  scenario 'user adds invalid links', js: true do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'http://ya. ru'

    click_on 'Create Answer'

    expect(page).to_not have_link 'My gist', href: 'http://ya. ru'
  end
  end
end
