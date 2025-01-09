class SubjectsController < ApplicationController
  before_action :check_user_logged_in, only: [:create, :new]

  def new
    session[:return_to] = request.referer
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.user = current_user # Userオブジェクトを直接関連付け
    if @subject.save
      redirect_to session.delete(:return_to) || root_path, notice: '科目が登録されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def subject_params
    params.require(:subject).permit(:name)
  end

  def current_user
    User.find_by(id: session[:login_uid])
  end

  def check_user_logged_in
    unless current_user
      redirect_to login_path, alert: "ログインしてください。"
    end
  end
end
