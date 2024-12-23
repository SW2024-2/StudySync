class GoalsController < ApplicationController
  # 指定したアクションでレポートを設定する
  before_action :set_report, only: [:index, :new, :create, :edit, :update, :destroy]
  
  # 指定したアクションで目標を設定する
  before_action :set_goal, only: [:edit, :update, :destroy]

  # 目標一覧画面を表示
  def index
    # 日付情報を取得
    today = Date.today
    start_of_week = today.beginning_of_week
    end_of_week = today.end_of_week
    start_of_month = today.beginning_of_month
    end_of_month = today.end_of_month

    # 今日の目標を取得（現在のユーザー、期間が'daily'の目標）
    @todays_goals = Goal.where(user: current_user, period: 'daily')

    # 今週の目標を取得（現在のユーザー、期間が'weekly'の目標）
    @this_weeks_goals = Goal.where(user: current_user, period: 'weekly')

    # 今月の目標を取得（現在のユーザー、期間が'monthly'の目標）
    @this_months_goals = Goal.where(user: current_user, period: 'monthly')

    # 各目標の進捗度を計算
    calculate_progress_for_goals(@todays_goals, 'today')
    calculate_progress_for_goals(@this_weeks_goals, 'this_week')
    calculate_progress_for_goals(@this_months_goals, 'this_month')
  end

  # 新しい目標の作成画面を表示
  def new
    @goal = Goal.new
  end

  # 目標を作成
  def create
    # 指定されたレポートを取得
    @report = Report.find(params[:report_id])
    
    # 新しい目標をレポートに紐づけて作成
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user
  
    # 目標を保存し、成功したら目標一覧にリダイレクト
    if @goal.save
      redirect_to report_goals_path(@report), notice: '目標が作成されました'
    else
      render :new, alert: '目標の作成に失敗しました'
    end
  end

  # 目標の編集画面を表示
  def edit
  end

  # 目標を更新
  def update
    # 時間と分を合計して学習時間を計算
    total_study_time = (@goal.study_time_hours.to_i * 60) + @goal.study_time_minutes.to_i

    # 学習時間を更新し、成功したら目標一覧にリダイレクト
    if @goal.update(goal_params.merge(study_time: total_study_time))
      redirect_to report_goals_path(@goal.report), notice: '目標が更新されました。'
    else
      render :edit
    end
  end

  # 目標を削除
  def destroy
    @goal.destroy
    redirect_to report_goals_path(@report), notice: '目標が削除されました。'
  end

  private

  # Strong Parameters: 許可するパラメータを定義
  def goal_params
    params.require(:goal).permit(:title, :study_time_hours, :study_time_minutes, :period, subject_ids: [])
  end

  # レポートを設定
  def set_report
    if params[:report_id]
      # URLパラメータに基づいてレポートを取得
      @report = current_user.reports.find_by(id: params[:report_id])
    else
      # レポートがない場合、新しいレポートを作成
      @report = current_user.reports.create(title: "新しいレポート")
    end
  end

  # 指定された目標を設定
  def set_goal
    @goal = @report.goals.find(params[:id]) if @report
  end

  # 時間と分を合計して分単位の学習時間を計算
  def calculate_total_study_time(hours, minutes)
    (hours * 60) + minutes
  end

  # 指定された目標の進捗度を計算してインスタンス変数に設定
  def calculate_progress_for_goals(goals, period)
    goals.each do |goal|
      goal_progress = calculate_progress(goal, period)
      goal.instance_variable_set(:@progress, goal_progress)
    end
  end

  # 各目標の進捗度を計算
  def calculate_progress(goal, period)
    # 指定された期間に応じて学習時間を取得
    total_study_time = case period
    when 'today'
      StudyLog.study_time_today(current_user)[goal.title] || 0
    when 'this_week'
      StudyLog.study_time_this_week(current_user)[goal.title] || 0
    when 'this_month'
      StudyLog.study_time_this_month(current_user)[goal.title] || 0
    else
      0
    end

    # 目標時間が0の場合、進捗度は0%
    return 0 if goal.study_time == 0

    # 進捗度を計算
    (total_study_time.to_f / goal.study_time.to_f) * 100
  end

  # 現在ログイン中のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
