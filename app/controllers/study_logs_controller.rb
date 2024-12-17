class StudyLogsController < ApplicationController
  before_action :set_study_log, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:edit, :destroy]

  # 学習記録の一覧を表示
  def index
    if session[:login_uid]
      @study_logs = StudyLog.includes(:user).order(created_at: :desc)
      render "study_logs/index"
    else
      render "top/login"
    end
  end

  # 学習記録詳細
  def show
  end

  # 新規作成フォーム
  def new
    @study_log = StudyLog.new
  end

  # 学習記録を作成
  def create
    @study_log = StudyLog.new(study_log_params)
    @study_log.user = current_user

    # 学習時間を計算
    @study_log.study_time = calculate_study_time(@study_log)

    if @study_log.save
      redirect_to @study_log, notice: "学習記録が作成されました。"
    else
      render :new
    end
  end

  # 学習記録編集フォーム
  def edit
  end

  # 学習記録を更新
  def update
    if @study_log.update(study_log_params)
      @study_log.study_time = calculate_study_time(@study_log)
      @study_log.save
      redirect_to root_path, notice: "学習記録が更新されました。"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  # 学習記録を削除
  def destroy
    @study_log.destroy
    redirect_to study_logs_path, notice: "記録が削除されました。"
  end

  private

  # 学習記録を取得
  def set_study_log
    @study_log = StudyLog.find(params[:id])
  end

  # 所有者確認
  def check_ownership
    unless @study_log.user == current_user
      flash[:alert] = "他のユーザーの記録を編集したり削除することはできません。"
      redirect_to root_path
    end
  end

  # Strong Parameters
  def study_log_params
    params.require(:study_log).permit(
      :subject, 
      :note, 
      :study_time, 
      :study_time_method, 
      :stopwatch_time, 
      :timer_time, 
      :timer_remaining,
      :study_time_hours, # 時間
      :study_time_minutes # 分
    )
  end

  # 現在のユーザーを取得
  def current_user
    User.find_by(id: session[:login_uid])
  end

  # 学習時間の計算ロジック
  def calculate_study_time(study_log)
    study_time = 0

    case study_log.study_time_method
    when 'manual'
      # 時間と分を使って学習時間を計算
      hours = study_log.study_time_hours.to_i
      minutes = study_log.study_time_minutes.to_i
      study_time = (hours * 60) + minutes
    when 'stopwatch'
      # ストップウォッチの時間を使って学習時間を計算
      study_time = study_log.stopwatch_time.to_i / 60 if study_log.stopwatch_time.present?
    when 'timer'
      # タイマーの時間を使って学習時間を計算
      if study_log.timer_time.present?
        if study_log.timer_remaining.present?
          study_time = (study_log.timer_time.to_i / 60) - (study_log.timer_remaining.to_i / 60)
          study_time = [study_time, 0].max
        else
          study_time = study_log.timer_time.to_i / 60
        end
      end
    end

    study_time
  end
end
