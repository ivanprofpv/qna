require 'rails_helper'

feature 'User can sign up' do
  given(:user) { User.create(email: 'user@test.ru',
         password: '12345678', confirmed_at: Time.zone.now) }
  background { visit new_user_registration_path }

  scenario 'Unregistered user trying to register', js: true do
    fill_in 'Email', with: 'fake_name@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content('A message with a confirmation link has been sent to your email address.')

    open_email('fake_name@mail.com')
    expect(current_email).to have_content('You can confirm your account email through the link below')

    current_email.click_link 'Confirm my account'
    expect(page).to have_content('Your email address has been successfully confirmed')
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
