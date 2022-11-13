require 'rails_helper'

feature 'User can add award to heir question' do

  describe 'authenticated user' do
    given(:user) { create(:user) }
    given(:image) { "#{Rails.root}/spec/fixtures/award_image.png" }

    background do
      sign_in(user)
      visit root_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Text question'
    end

    scenario 'can add an award to their question when creating' do
      within '.award' do
        fill_in 'Award title', with: 'Award title'

        attach_file 'Select image', image
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'adds an invalid reward (no picture)', js: true do
      within '.award' do
        fill_in 'Award title', with: 'Award title'
      end
      
      click_on 'Ask'

      expect(page).to have_content 'No image attached!'
    end

    scenario 'adds an invalid reward (no title)', js: true do
      within '.award' do
        attach_file 'Select image', image
      end

      click_on 'Ask'

      expect(page).to have_content "Award title can't be blank"
    end
  end
end
