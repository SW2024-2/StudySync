class StudyLogsController < ApplicationController
  def index
    @study_logs = StudyLog.includes(:user).order(created_at: :desc) # 学習ログを作成日時順で取得
  end

  def show
  end

  def new
    @study_log = StudyLog.new
  end

  def create
    @study_log = StudyLog.new(study_log_params)
    if @study_log.save
      redirect_to study_logs_path, notice: '学習記録が作成されました'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
    private

  def study_log_params
    params.require(:study_log).permit(:subject, :study_time, :note)
  end
end
