class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] # 作成と削除のみログイン必須

  def index
    @study_log = StudyLog.find(params[:study_log_id])
    @comments = @study_log.comments.includes(:user)
  end

  def create
    @study_log = StudyLog.find(params[:study_log_id])
    @comment = @study_log.comments.build(comment_params)
    @comment.user = current_user # ログイン中のユーザーを設定

    if @comment.save
      redirect_to study_log_comments_path(@study_log), notice: 'コメントを追加しました。'
    else
      redirect_to study_log_comments_path(@study_log), alert: 'コメントの追加に失敗しました。'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to study_log_comments_path(@comment.study_log), notice: 'コメントを削除しました。'
    else
      redirect_to study_log_comments_path(@comment.study_log), alert: 'コメントを削除できません。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
