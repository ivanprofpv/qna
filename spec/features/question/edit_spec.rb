require 'rails_helper'

feature 'User can edit his question' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    context 'with valid attributes' do
      scenario 'can edit his question' do

        within '.question-controls' do
          click_on 'Edit'
          fill_in 'Title', with: 'title text'
          fill_in 'Body', with: 'body text'
          click_on 'Save'
        end

        expect(page).to have_content 'title text'
        expect(page).to have_content 'body text'
      end

      scenario "can't edit other user's question" do
        visit question_path(other_question)

        expect(page).to_not have_link "Edit"
        expect(page).to_not have_selector "question-controls"
      end
    end

    context 'with invalid attributes' do
      scenario "can't edit his question" do

        within '.question-controls' do
          click_on 'Edit'
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end


    context 'attachments' do
      scenario 'add attachments' do
        within '.question-controls' do
          click_on 'Edit'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
      end

    scenario 'delete attachments' do
      within '.questions_main' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        click_on 'Edit'
        first('.attachment').click_on 'Delete attachment'
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

      scenario 'can not other user delete attachments' do
        visit question_path(other_question)
        
        expect(page).to_not have_link 'Delete attachment'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit questions' do
      visit question_path(question)
      expect(page).to_not have_link "Edit"
    end
  end
end
