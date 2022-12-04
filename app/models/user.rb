class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, through: :answers
  has_many :comments, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author?(subject)
    self.id == subject.user_id
  end

  def self.find_for_oauth(auth)
  end
end
