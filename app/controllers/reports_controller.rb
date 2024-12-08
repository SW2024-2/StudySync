class ReportsController < ApplicationController
  before_action :set_user
  before_action :set_study_times, only: :index

  def index
    @report = current_user.reports.last
    @goals = @report&.goals || []
    @current_goal = current_user.goals.order(created_at: :desc).first
    @study_time = @current_goal&.study_time || 0
  end

  private

  def set_user
    @user = current_user
    redirect_to login_path, alert: "ログインしてください。" unless @user
  end

  def set_study_times
    @todays_study_time = StudyLog.study_time_today(@user) || {}
    @this_weeks_study_time = StudyLog.study_time_this_week(@user) || {}
    @this_months_study_time = StudyLog.study_time_this_month(@user) || {}
    @total_study_time = StudyLog.total_study_time(@user)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
