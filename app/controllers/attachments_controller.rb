class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize @attachment.record, policy_class: AttachmentsPolicy
    @attachment.purge
  end
end
