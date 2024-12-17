class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  # フレンド一覧
  def index
    @friends = current_user.friends
  end

  # ユーザー検索機能
  def search
    if params[:query].present?
      @users = User.where('name LIKE ? OR uid LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
                   .where.not(id: current_user.id) # 自分自身は除外
    else
      @users = []
    end
  end

  def create
    friend = User.find(params[:friend_id])
    current_user.friendships.create!(friend: friend)
    redirect_to friendships_path, notice: "#{friend.name}さんを友達に追加しました。"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to friendships_path, alert: e.message
  end
  # 友達削除
  def destroy
    friend = User.find(params[:id])
    friendship = current_user.friendships.find_by(friend_id: friend.id)
    friendship&.destroy
    redirect_to friendships_path, notice: "#{friend.name}さんを友達から削除しました。"
  end
end
