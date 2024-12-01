class StudyLogsController < ApplicationController
  def index
    if session[:login_uid]
      @study_logs = StudyLog.includes(:user).order(created_at: :desc)
      render "study_logs/index"
    else
      render "top/login"
    end
  end

  def show
  end

  def new
    @study_log = StudyLog.new
  end

  def create
    # ログインしていない場合は、ログインページにリダイレクト
    if session[:login_uid].nil?
      flash[:alert] = "ログインが必要です。"
      redirect_to login_form_path
      return
    end

    @study_log = StudyLog.new(study_log_params)
    
    # ユーザーIDを設定
    @study_log.user = User.find_by(id: session[:login_uid])

    if @study_log.user.nil?
      flash[:alert] = "ユーザーが見つかりません。ログインし直してください。"
      redirect_to login_form_path
      return
    end

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
