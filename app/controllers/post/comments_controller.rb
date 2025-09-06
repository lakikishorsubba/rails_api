class Post::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  # GET /articles/:article_id/comments
  def index
    comments = @article.comments.includes(:user)
    render json: comments.as_json(
      only: [:id, :body, :created_at],
      include: { user: { only: [:id, :email] } }
    )
  end

  # POST /articles/:article_id/comments
  def create
    comment = @article.comments.new(comment_params.merge(user: current_user))

    if comment.save
      render json: comment.as_json(
        only: [:id, :body, :created_at],
        include: { user: { only: [:id, :email] } }
      ), status: :created
    else
      render json: { status: "error", errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = @article.comments.find(params[:id])
    if comment.user != current_user
      render json: { status: "error", errors: ["Not authorized"] }, status: :forbidden
      return
    end

    if comment.destroy
      render json: { status: "deleted" }
    else
      render json: { status: "error", errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  
  def comment_params
    params.require(:comment).permit(:body)
  end
end
