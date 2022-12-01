require 'rails_helper'

feature 'User can vote to question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'authenticated user', js: true do

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'vote up' do
      within '.question-container' do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '1'
      end
    end

    scenario 'vote down' do
      within '.question-container' do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '1'
      end
    end

    scenario 'canceled the vote up' do
      within '.question-container' do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '1'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '0'
      end
    end

    scenario 'canceled the vote down' do
      within '.question-container' do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '1'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '0'
      end
    end
  end

  scenario 'can not upvote your own question' do
    sign_in author
    visit question_path(question)
    within '.question-container' do
      expect(page).to_not have_css 'a.vote-up'
      expect(page).to_not have_css 'a.vote-down'
    end
  end

  describe 'unauthenticated user', js: true do

    scenario 'can not upvote' do
      visit question_path(question)
      expect(page).to_not have_css 'a.vote-up'
      expect(page).to_not have_css 'a.vote-down'
    end
  end
end