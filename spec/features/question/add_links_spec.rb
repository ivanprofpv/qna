require 'rails_helper'

feature 'User can add links to question', "
  in order to provide additional info to my question
  as an question's author
  i'd like to be able to add links
" do
  
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ivanprofpv/8ff9f7ff3c27dbac5ccec5cbc6aff558' }

  scenario 'User adds link when asks question' do
    fill_in 'Title', with: 'title text'
    fill_in 'Body', with: 'body text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    save_and_open_page
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end