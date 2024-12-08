class GoalsController < ApplicationController
  before_action :set_goal, only: [:edit, :update, :destroy]

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to report_index_path, notice: '目標が設定されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to report_index_path, notice: '目標が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @goal.destroy
    redirect_to report_index_path, notice: '目標が削除されました。'
  end
  
  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:title, :study_time)  # study_timeを追加する
  end

end