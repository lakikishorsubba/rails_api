class Post::ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    articles = Article.includes(:user, :comments, files_attachments: :blob).all
    render json: articles.as_json(
      methods: [:likes_count, :file_urls],
      include: { 
        user: { only: [:id, :email] }, 
        comments: { 
          include: { user: { only: [:id, :email] } },
          only: [:id, :body]
        }
      }
    )
  end

  # GET /articles/1
  def show
    render json: @article.as_json(
      methods: [:likes_count, :file_urls],
      include: { 
        user: { only: [:id, :email] }, 
        comments: { 
          include: { user: { only: [:id, :email] } },
          only: [:id, :body]
        }
      }
    )
  end

  # POST /articles
  def create
    article = current_user.articles.new(article_params)

    # Attach files if any
    if params[:files].present?
      Array(params[:files]).each do |file|
        article.files.attach(file)
      end
    end

    if article.save
      render json: article.as_json(
        methods: [:likes_count, :file_urls],
        include: { 
          user: { only: [:id, :email] },
          comments: { 
            include: { user: { only: [:id, :email] } },
            only: [:id, :body]
          }
        }
      ), status: :created
    else
      render json: { status: "error", errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/:id
  def update
    if @article.user != current_user
      render json: { status: "error", errors: ["Not authorized"] }, status: :forbidden
      return
    end

    # Attach new files if any
    if params[:files].present?
      Array(params[:files]).each do |file|
        @article.files.attach(file)
      end
    end

    if @article.update(article_params)
      render json: @article.as_json(
        methods: [:likes_count, :file_urls],
        include: { 
          user: { only: [:id, :email] },
          comments: { 
            include: { user: { only: [:id, :email] } },
            only: [:id, :body]
          }
        }
      ), status: :ok
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
    render json: { status: "deleted" }, status: :ok
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end
end
