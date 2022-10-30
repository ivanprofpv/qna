require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belongs_to :user }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
