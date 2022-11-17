module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, :find_vote, only: %i[like dislike]
  end

  def like
    processing_vote(:like)
  end

  def dislike
    processing_vote(:dislike)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params['id'])
  end

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def processing_vote(action)
    if !@vote.present?
      create_vote(action)
    elsif @vote.send("#{action}?")
      @vote.vote_weight = nil
      @vote.destroy
      render_votable
    else
      @vote.destroy
      create_vote(action)
    end
  end

  def create_vote(action)
    @vote = @votable.votes.new(user: current_user, vote_weight: action)
    if @vote.save
      render_votable
    else
      render json: @vote.errors.messages, status: :unprocessable_entity
    end
  end

  def render_votable
    render json: {
      votable_id: @votable.id,
      rating: @votable.rating,
      model: @vote.votable_type.underscore,
      user_vote: @vote.vote_weight
    }
  end
end