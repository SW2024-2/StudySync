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
    @study_log = StudyLog.find(params[:id])  # :idを使って対象の学習記録を取得
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "学習記録が見つかりません。"
    redirect_to study_logs_path  # 存在しないIDの場合は、一覧ページにリダイレクト
  end


  def new
    @study_log = StudyLog.new
  end

  def create
    if session[:login_uid].nil?
      flash[:alert] = "ログインが必要です。"
      redirect_to login_form_path
      return
    end

    @study_log = StudyLog.new(study_log_params)
    @study_log.user = User.find_by(id: session[:login_uid])

    if @study_log.user.nil?
      flash[:alert] = "ユーザーが見つかりません。ログインし直してください。"
      redirect_to login_form_path
      return
    end

    if @study_log.save
      redirect_to root_path, notice: '学習記録が作成されました'
    else
      render :new
    end
  end

  def edit
    @study_log = StudyLog.find(params[:id])
  end

  def update
    @study_log = StudyLog.find(params[:id])

    if @study_log.update(study_log_params)
      redirect_to root_path, notice: "学習記録が更新されました。"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  def destroy
    @study_log = StudyLog.find_by(id: params[:id])  # find_byを使ってnilの場合の処理を追加
    if @study_log
      @study_log.destroy
      flash[:notice] = "学習記録が削除されました。"
    else
      flash[:alert] = "学習記録が見つかりません。"
    end
    redirect_to root_path  # TOP画面にリダイレクト
  end


  private

  def study_log_params
    params.require(:study_log).permit(:subject, :study_time, :note)
  end
end
