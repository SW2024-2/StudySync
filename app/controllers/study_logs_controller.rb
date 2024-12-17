class StudyLogsController < ApplicationController
  # 操作対象の学習記録を設定する（show, edit, update, destroyで使う）
  before_action :set_study_log, only: [:show, :edit, :update, :destroy]
  
  # 編集と削除の前に、現在のユーザーがその学習記録の所有者かを確認する
  before_action :check_ownership, only: [:edit, :destroy]

  # 学習記録の一覧を表示する
  def index
    if session[:login_uid]
      @study_logs = StudyLog.includes(:user).order(created_at: :desc)
      render "study_logs/index"
    else
      render "top/login"
    end
  end

  # 単一の学習記録を表示する
  def show
  end

  # 新規学習記録作成画面を表示する
  def new
    @study_log = StudyLog.new
  end

  # 学習記録を新規作成する
  def create
    @study_log = StudyLog.new(study_log_params)
    @study_log.user = current_user
  
    study_time = 0
  
    if @study_log.study_time_method == 'manual' && @study_log.study_time.present?
      # 手動入力の学習時間
      study_time = @study_log.study_time.to_i
    elsif @study_log.study_time_method == 'stopwatch' && @study_log.stopwatch_time.present?
      # ストップウォッチ時間（秒 → 分変換）
      study_time = @study_log.stopwatch_time.to_i / 60
    elsif @study_log.study_time_method == 'timer' && @study_log.timer_time.present?
      # タイマー時間から実際の学習時間を計算
      if @study_log.timer_remaining.present?
        # タイマー設定時間（分） - 残り時間（分）
        study_time = (@study_log.timer_time.to_i / 60) - (@study_log.timer_remaining.to_i / 60)
        study_time = [study_time, 0].max  # 負の値にならないようにする
      else
        # 残り時間が未入力の場合はタイマー設定時間を使用
        study_time = @study_log.timer_time.to_i / 60
      end
    end
  
    @study_log.study_time = study_time
  
    if @study_log.save
      redirect_to @study_log, notice: "学習記録が作成されました。"
    else
      render :new
    end
  end


  # 学習記録編集画面を表示する
  def edit
  end

  # 学習記録を更新する
  def update
    if @study_log.update(study_log_params)
      redirect_to root_path, notice: "学習記録が更新されました。"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  # 学習記録を削除する
  def destroy
    @study_log.destroy
    redirect_to study_logs_path, notice: '記録が削除されました'
  end

  private

  def set_study_log
    @study_log = StudyLog.find(params[:id])
  end

  def check_ownership
    unless @study_log.user == current_user
      flash[:alert] = "他のユーザーの記録を編集したり削除することはできません。"
      redirect_to root_path
    end
  end

  def study_log_params
    params.require(:study_log).permit(:subject, :study_time, :note, :study_time_method, :stopwatch_time, :timer_time)
  end


  def current_user
    User.find_by(id: session[:login_uid])
  end
end
