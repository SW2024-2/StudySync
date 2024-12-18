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
      # タイマーが完了している場合、学習時間を計算
      @study_log.study_time = calculate_study_time(@study_log)

      # 保存を一度だけ行う
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
    case study_log.study_time_method
    when 'manual'
      # 手動の場合は、入力された時間（時間、分）で計算
      hours = study_log.study_time_hours.to_i
      minutes = study_log.study_time_minutes.to_i
      study_time = (hours * 60) + minutes # 総分数
    when 'stopwatch'
      # ストップウォッチ時間が設定されている場合（秒単位）
      stopwatch_seconds = study_log.stopwatch_time.to_i
      study_time = stopwatch_seconds / 60 # 分単位に切り捨て
    when 'timer'
      # タイマーが完了している場合、残り時間が0であれば設定時間を学習時間にする
      if study_log.timer_remaining.to_i == 0
        study_time = study_log.timer_time.to_i / 60 # タイマー設定時間をそのまま使用
      else
        # タイマー途中で停止した場合、設定時間から残り時間を引いた分を学習時間にする
        study_time = (study_log.timer_time.to_i - study_log.timer_remaining.to_i) / 60
      end
    else
      study_time = 0 # 未設定の場合はゼロ
    end
  
    study_time # 分単位の学習時間
  end
end

