# app/controllers/subjects_controller.rb
class SubjectsController < ApplicationController
  def new
    session[:return_to] = request.referer
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
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
end
