require 'rails_helper'

feature 'User can add award to heir question', "
  so that for the best answer,
  another user can receive a reward
" do

  describe 'authenticated user' do

    scenario 'can add an award to their question when creating'

    scenario 'adds an invalid reward (no picture)'

    scenario 'adds an invalid reward (no title)'

end