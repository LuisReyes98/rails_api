class PostsController < ApplicationController


  rescue_from Exception do |e|
    # log.error "#{e.message}"  #si el programa tuviera un log
    render json: { error: e.message }, status: :internal_error
  end

  #EL ultimo rescue from tiene mas prioridad que los especificados anteriormente
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end


  #GET /posts
  def index
    @posts = Post.where(published: true)
    render json: @posts, status: :ok
  end
  
  #GET /posts/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok

  end

  #POST /posts
  def create
    #con ! se arroja una excepcion para poder manejarla
    @post = Post.create!(create_params)
    render json: @post , status: :created
  end
  
  #PUT /posts
  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post , status: :ok

  end
  
  private

    def create_params
      params.require(:post).permit(:title,:content,:published,:user_id)
    end
    
    def update_params
      params.require(:post).permit(:title,:content,:published)
    end
  
end