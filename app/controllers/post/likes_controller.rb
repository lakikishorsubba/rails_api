class Post::LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article

   def toggle
    like = @article.likes.find_by(user_id: current_user.id)

    if like
      like.destroy
      render json: { status: "unliked", likes_count: @article.likes.count }
    else
      @article.likes.create!(user_id: current_user.id)
      render json: { status: "liked", likes_count: @article.likes.count }
    end
  end

    private

    def set_article
        @article = Article.find(params[:article_id])
    end
end
