require 'sphinx_helper'

SCOPES = %w[User Question Answer Comment].freeze

feature 'User can search for users/questions/answers/comments', js: true do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, title: 'Ruby Question', user:) }
  given!(:answer) { create(:answer, body: 'Ruby Answer', question:, user:) }
  given!(:comment) { create(:comment, body: 'Ruby Comment', commentable: answer, user:) }

  background { visit questions_path }

  # rubocop:disable RSpec/MultipleExpectations
  scenario 'User searches in All scope', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in(placeholder: 'Search for:', with: 'ruby')
      select 'All', from: :scope
      click_on 'Search'

      expect(page).to have_content(user.email)
      expect(page).to have_content(question.title)
      expect(page).to have_content(answer.body)
      expect(page).to have_content(comment.body)
    end
  end
  # rubocop:enable RSpec/MultipleExpectations

  SCOPES.each do |scope|
    scenario "User searches in #{scope}s scope", sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in(placeholder: 'Search for:', with: 'ruby')
        select scope, from: :scope
        click_on 'Search'

        content = scope == 'User' ? user.email : "Test #{scope}"
        expect(page).to have_content(content)
      end
    end
  end

  scenario 'User founds nothing', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in(placeholder: 'Search for:', with: 'ruby')
      select 'All', from: :scope
      click_on 'Search'

      expect(page).to have_content('No result')
    end
  end

  scenario 'User tries to search without query', sphinx: true do
    ThinkingSphinx::Test.run do
      click_on 'Search'

      expect(page).to have_content('No result')
    end
  end
end