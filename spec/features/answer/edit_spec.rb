require 'rails_helper'

feature 'user can edit his answer' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answer_block' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'can not edit other answer' do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

    scenario 'other user can not edit answer' do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edit his answer with errors' do
      sign_in(user)
      visit question_path(question)

      within '.answer_block' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'add attachments' do
      sign_in(user)
      visit question_path(question)
      within '.answer_block' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete attachments' do
      sign_in(user)
      visit question_path(question)
      within '.answer_block' do
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
      sign_in(user)
      visit question_path(other_question)

      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
