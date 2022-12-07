require 'rails_helper'

feature 'User can sign in through oauth' do

  OmniAuth.config.test_mode = true

  background do
    visit new_user_session_path
  end

  scenario 'user sign in through GitHub' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github', uid: '123456', info: { email: 'mock@user.com' })

    click_link('Sign in with GitHub')

    expect(page).to have_content('Successfully authenticated from Github account.')
  end

  scenario 'user sign in through Github invalid credentials' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    click_link('Sign in with GitHub')

    expect(page).to have_content('Could not authenticate you from GitHub')
  end

  scenario 'user sign in through Vkontakte' do
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte', uid: '123456', info: { email: 'mocked@user.com' }
    )

    click_link('Sign in with Vkontakte')

    expect(page).to have_content('Successfully authenticated from vkontakte account.')
  end

  scenario 'user sign in through Vkontakte invalid credentials' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    
    click_link('Sign in with Vkontakte')

    expect(page).to have_content 'Email confirmation'

    fill_in 'Email', with: 'oauth@test.com'
    click_button 'Send confirmation link'

    open_email('oauth@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content('Your email address has been successfully confirmed')

    click_link('Sign in with Vkontakte')

    expect(page).to have_content('Successfully authenticated from Vkontakte account.')
  end

end