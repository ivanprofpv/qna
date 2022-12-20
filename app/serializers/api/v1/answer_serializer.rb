class Api::V1::AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :question_id, :body, :created_at, :updated_at

  belongs_to :user
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end

