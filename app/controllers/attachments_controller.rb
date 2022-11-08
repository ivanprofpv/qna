class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    return unless current_user.author?(@attachment.record)

    @attachment.purge
  end
end
