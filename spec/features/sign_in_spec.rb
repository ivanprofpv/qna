require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  i'd like to be able to sign in
" do
  given(:user) { create(:user) }
  given(:unconfirmed_user) { create(:user, :unconfirmed) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Registered user tries to sign in with unconfirmed email' do
    fill_in 'Email', with: unconfirmed_user.email
    fill_in 'Password', with: unconfirmed_user.password
    click_button 'Log in'

    expect(page).to have_content('You have to confirm your email address before continuing.')
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
