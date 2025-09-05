class Post::LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article

    def create
        like = @article.likes.new(user: current_user)

        if like.save
            render json: {status: "Liked", likes_count: @article.likes_count}
        else 
            render json: {status: "Error", error: like.error.full_messages}, status: :unprocessable_entity
        end
    end

    def destroy
        like = @article.likes.find_by(user: current_user)
        if like
            like.destroy
            render json: {status: "unliked", likes_count:@article.likes_count}
        else
            render json: {status: "error", messages: "not liked yet"}, status: :not_found
    
        end
    end

    private

    def set_article
        @article = Article.find(params[:article_id])
    end
end
