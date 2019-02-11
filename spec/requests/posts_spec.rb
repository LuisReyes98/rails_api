require "rails_helper"
require "byebug"

RSpec.describe "Posts", type: :request  do
  describe "GET /posts" do
    before { get '/posts' }

    it "should return ok" do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty

      expect(response).to have_http_status(200)      
    end

    
  end  
  
  describe "with data in the DB" do
    #let() es de rspec     create_list() es de factory bot 
    let!(:posts) { create_list(:post,10,published: true) }
    #let  #el bloque se evalua de forma laizy , no se crean los datos hasta que se hace referencia a la variable
    #let! se crean los datos de inmediato
    it "should return all the published posts" do
      get '/posts'
      #byebug #para debuggear , es lo equivalente a un debugger en JS
      payload = JSON.parse(response.body)  
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)      
      
    end
    
    
  end
  
  describe "GET /posts/{id}" do
    let!(:post) { create(:post) }


    it "Should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)      
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(200)      
      
    end
  end

  describe "POST /posts" do
    let!(:user) { create(:user) }

    it "should create a post" do
      req_payload = {
        post:{
          title: "titulo",
          content: "Content",
          published: false,
          user_id: user.id
        }
      }
      #POST HTTP
      post "/posts" , params: req_payload
  
      payload = JSON.parse(response.body)
  
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      #Se puede usar numero o keyword del estado http
      expect(response).to have_http_status(:created)  
    end

    it "should return and error message on invalid post" do
      req_payload = {
        post:{
          content: "Content",
          published: false,
          user_id: user.id
        }
      }
      #POST HTTP
      post "/posts" , params: req_payload
  
      payload = JSON.parse(response.body)
  
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      #Se puede usar numero o keyword del estado http
      expect(response).to have_http_status(:unprocessable_entity) 
    end
    


  end

  describe "PUT /posts/{id} " do
    let!(:article) { create(:post) }

    it "should edit a post" do
      req_payload = {
        post:{
          title: "titulo",
          content: "Content",
          published: true,
        }
      }
      #PUT HTTP
      put "/posts/#{article.id}" , params: req_payload
  
      payload = JSON.parse(response.body)
  
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(article.id)
      expect(response).to have_http_status(:ok)  
    end


    it "should return and error message on invalid post" do
      req_payload = {
        post:{
          title: nil,
          content: nil,
          published: true,
        }
      }
      #PUT HTTP
      put "/posts/#{article.id}" , params: req_payload
  
      payload = JSON.parse(response.body)
  
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)  
    end
  end
  
  
end
