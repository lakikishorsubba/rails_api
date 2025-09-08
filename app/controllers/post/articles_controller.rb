class Post::ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] 
  before_action :set_article, only: [:show, :update, :destroy] #to the specific function set_article, allow this cruds

  def index
    #include is a database level optimization
    # will pre-load all the records including its accociation.
    articles = Article.includes(:user, :comments, files_attachments: :blob).all #all is to fetch the records
    #customize the rendering
    render json: articles.as_json(
      methods: [:likes_count, :file_urls], #calling custom ruby method
      include: { #include includes associated data (article and comment)
        user: { only: [:id, :email] }, 
        comments: { include: { 
          user: { only: [:id, :email] } }, 
          only: [:id, :body]}
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
      @article.files.purge #rails remove record from db and file from local storage.
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
