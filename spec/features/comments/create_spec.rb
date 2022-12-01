require 'rails_helper'

feature 'User can add comment for question and answers' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment to question' do
      within "#question-#{question.id}" do
          fill_in(id: 'comment_body', with: 'question comment')
          click_on 'Add a comment'
      end

      expect(page).to have_content('question comment')
    end

    scenario 'add comment to answer' do
      within "#answer-#{answer.id}" do
        fill_in(id: 'comment_body', with: 'answer comment')
        click_on 'Add a comment'
      end
      
      expect(page).to have_content 'answer comment'
    end

    scenario 'add comment with error' do
      within "#question-#{question.id}" do
        click_on 'Add a comment'
      end

      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    scenario 'do not add comment' do
      visit question_path(question)

      expect(page).not_to have_content('Add a comment')
    end
  end

  describe 'push to channel' do
    scenario 'Comments appears for another users after create', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#question-#{question.id}" do
          fill_in(id: 'comment_body', with: 'question comment')
          click_on 'Add a comment'
        end

        within "#answer-#{answer.id}" do
          fill_in(id: 'comment_body', with: 'answer comment')
          click_on 'Add a comment'
        end
        sleep 2
        expect(page).to have_content 'question comment'
        expect(page).to have_content 'answer comment'
      end

      sleep 2
      Capybara.using_session('guest') do
        expect(page).to have_content('question comment')
        expect(page).to have_content('answer comment')
      end
    end
  end

end
