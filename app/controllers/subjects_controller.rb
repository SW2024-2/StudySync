class SubjectsController < ApplicationController
  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      # リファラ（戻る元のURL）にリダイレクト
      redirect_to params[:return_to] || study_logs_path, notice: "科目が登録されました。"
    else
      render :new
    end
  end

  private

  def subject_params
    params.require(:subject).permit(:name)
  end
end
