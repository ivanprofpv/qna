require 'rails_helper'

feature 'User can sign up' do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'Unregistered user trying to register' do
    fill_in 'Email', with: 'fake_name@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unauthenticated user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Password confirmation is invalid' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '2342342'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
