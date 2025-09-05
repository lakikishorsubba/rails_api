  class Post::ArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_article, only: [:show, :update, :destroy]

    # GET /articles
    def index
      articles = Article.includes(:user, :comments).all
      render json: articles.as_json(
        methods: [:likes_count],
        include: { 
          user: { only: [:id, :email] }, 
          comments: { 
            include: { user: { only: [:email] } } 
          }
        }
      )
    end

    # GET /articles/1
    def show
      render json: @article.as_json(
        methods: [:likes_count],
        include: { 
          user: { only: [:id, :email] }, 
          comments: { 
            include: {
               user: { only: [:id, :email] } }, only: [:id, :body] } 
        }
      )
    end

    # POST /articles
    def create
      article = current_user.articles.new(article_params)
      if article.save
        render json: { status: "created", data: article }, status: :created
      else
        render json: { status: "error", errors: article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /articles/1
    # PATCH/PUT /articles/:id
  def update
    # First check ownership
    if @article.user != current_user
      render json: { status: "error", errors: ["Not authorized"] }, status: :forbidden
      return
    end

    # Then attempt update
    if @article.update(article_params)
      render json: { status: "updated", data: @article }
    else
      render json: { status: "error", errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    if @article.user != current_user
      render json: { status: "error", errors: ["Not authorized"] }, status: :forbidden
      return
    end

    @article.destroy
    render json: { status: "deleted" }
  end
    
    private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description)
    end
  end
