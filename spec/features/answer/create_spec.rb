require 'rails_helper'

feature 'The user can write the answer in the question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write the answer in the question' do
      fill_in 'Your answer', with: 'text body'
      click_on 'Create Answer'
      expect(page).to have_content 'text body'
    end

    scenario 'creates answer with errors' do
      click_on 'Create Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can attach files to the answer' do
      fill_in 'Your answer', with: 'text body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'unauthenticated user' do
    scenario "can't write an answer" do
      visit question_path(question)
      expect(page).to_not have_button 'Create Answer'
    end
  end

  describe "checking mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text body'
        click_on 'Create Answer'

        expect(page).to have_content question.title
        expect(page).to have_content 'text body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text body'
      end
    end
  end
end
