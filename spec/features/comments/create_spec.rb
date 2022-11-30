require 'rails_helper'

feature 'User can add comment for question and answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  # describe 'Authenticated user' do
  #   background do
  #     sign_in(user)
  #     visit question_path(question)
  #   end

  #   scenario 'add comment to question' do

  #   end

  #   scenario 'add comment to answer' do

  #   end

  #   scenario 'add comment with error' do

  #   end
  # end

  # describe 'Unauthenticated user' do
  #   scenario 'do not add comment' do

  #   end
  # end

  describe 'push to channel' do
    scenario 'Comments appears for another users after create', js: true do

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        
        within '.question-container' do
          fill_in(id: 'comment_body', with: 'Test question comment')
          click_button 'Add a comment'
        end
        save_and_open_page
        within '.answers' do
          fill_in(id: 'comment_body', with: 'Test answer comment')
          click_button 'Add a comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Test question comment')
        expect(page).to have_content('Test answer comment')
      end
    end
  end

end