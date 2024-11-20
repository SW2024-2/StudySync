class StudyLogsController < ApplicationController
  def index
    @study_logs = StudyLog.includes(:user).order(created_at: :desc) # 学習ログを作成日時順で取得
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
