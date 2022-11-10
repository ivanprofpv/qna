require 'rails_helper'

feature 'User can add links to answer', "
  in order to provide additional info to my answer
  as an question's author
  i'd like to be able to add links
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ivanprofpv/8ff9f7ff3c27dbac5ccec5cbc6aff558' }

  background do
    sign_in(user)

    visit question_path(question)
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
