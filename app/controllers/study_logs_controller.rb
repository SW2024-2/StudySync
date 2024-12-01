class StudyLogsController < ApplicationController
  # 操作対象の学習記録を設定する（show, edit, update, destroyで使う）
  before_action :set_study_log, only: [:show, :edit, :update, :destroy]
  
  # 編集と削除の前に、現在のユーザーがその学習記録の所有者かを確認する
  before_action :check_ownership, only: [:edit, :destroy]

  # 学習記録の一覧を表示する
  def index
    # ログインしている場合は、学習記録を降順で並べ替えて表示
    if session[:login_uid]
      @study_logs = StudyLog.includes(:user).order(created_at: :desc)
      render "study_logs/index"
    else
      # ログインしていなければ、ログイン画面を表示
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
    @study_log = StudyLog.new(study_log_params) # 入力されたデータで新しい学習記録を作成
    @study_log.user = current_user  # 現在のユーザーを設定（ログインユーザー）

    if @study_log.save # 保存に成功した場合
      # 成功メッセージと共にトップページにリダイレクト
      redirect_to root_path, notice: '学習記録が作成されました'
    else
      # 保存に失敗した場合は、新規作成画面を再度表示
      render :new
    end
  end

  # 学習記録編集画面を表示する
  def edit
  end

  # 学習記録を更新する
  def update
    # 入力されたデータで学習記録を更新
    if @study_log.update(study_log_params)
      # 更新成功メッセージと共にトップページにリダイレクト
      redirect_to root_path, notice: "学習記録が更新されました。"
    else
      # 更新失敗時はエラーメッセージを表示し、編集画面を再度表示
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  # 学習記録を削除する
  def destroy
    # 学習記録を削除
    @study_log.destroy
    # 削除成功メッセージと共に学習記録一覧ページにリダイレクト
    redirect_to study_logs_path, notice: '記録が削除されました'
  end

  private

  # 操作対象の学習記録をデータベースから取得
  def set_study_log
    @study_log = StudyLog.find(params[:id])
  end

  # 編集や削除のアクションが呼ばれる前に、現在のユーザーがその学習記録の所有者かを確認
  def check_ownership
    # 学習記録が現在のユーザーに紐づいているかを確認
    unless @study_log.user == current_user
      flash[:alert] = "他のユーザーの記録を編集したり削除することはできません。"  # メッセージを表示
      redirect_to root_path  # トップページにリダイレクト
    end
  end

  # 学習記録のパラメータを許可する（subject, study_time, noteのみを受け付ける）
  def study_log_params
    params.require(:study_log).permit(:subject, :study_time, :note)
  end

  # 現在ログインしているユーザーを取得する
  def current_user
    User.find_by(id: session[:login_uid])  # session[:login_uid]がログインユーザーのIDである前提
  end
end