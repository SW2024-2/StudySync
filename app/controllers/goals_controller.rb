class GoalsController < ApplicationController
  before_action :set_report, only: [:new, :create, :edit, :update, :destroy]

  def index
    # 今日、今週、今月の目標を期間別に取得
    @todays_goals = current_user.goals.where(period: 'daily')
    @this_weeks_goals = current_user.goals.where(period: 'weekly')
    @this_months_goals = current_user.goals.where(period: 'monthly')
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user  # ログイン中のユーザーを設定

    if @goal.save
      redirect_to report_path(@report), notice: '目標が設定されました。'
    else
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    
    if @goal.update(goal_params)
      redirect_to report_path(@report), notice: '目標が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to report_path(@report), notice: '目標が削除されました。'
  end

  private

  # 現在のユーザーのレポートを取得するメソッド
  def current_user_reports
    current_user.reports
  end

  # レポートを設定する
  def set_report
    return if action_name == 'index'  # index アクションではスキップ

    # report_id がパラメータとして渡されていない場合のエラーハンドリング
    @report = current_user_reports.find_by(id: params[:report_id])
    # レポートが見つからない場合は、レポート一覧ページにリダイレクト
    redirect_to reports_path, alert: 'レポートが見つかりませんでした。' unless @report
  end

  # 目標のパラメータを許可する
  def goal_params
    params.require(:goal).permit(:title, :study_time, :period)
  end

  # 現在のユーザーを取得する
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
