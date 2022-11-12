class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, through: :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(subject)
    self.id == subject.user_id
  end
end
