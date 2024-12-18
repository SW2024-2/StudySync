class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    study_log = StudyLog.find(params[:study_log_id])
    study_log.likes.create!(user: current_user)
    redirect_to request.referer || root_path
  end

  def destroy
    study_log = StudyLog.find(params[:study_log_id])
    like = study_log.likes.find_by(user: current_user)
    like&.destroy
    redirect_to request.referer || root_path
  end
end
