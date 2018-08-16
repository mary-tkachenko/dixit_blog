require 'sinatra'
require "sinatra/activerecord"
require 'sinatra/base'
require 'sinatra/flash'
require './models/post.rb'
require './models/visual.rb'
require './models/user.rb'

enable :sessions

# set :database, {adapter: "postgresql", database: "dixit"}
# set :session_secret, ENV.fetch('SESSION_SECRET')

before do
    if session[:user_id]
        @specific_user = User.find(session[:user_id])
    end
end

get "/" do
    erb :index, :layout => :layout_mainpage
end

get "/dixit/sign_in" do
    erb :sign_in, :layout => :layout_user
end


post "/dixit/sign_in" do
    @user = User.find_by(username: params[:username])
  
    # checks to see if the user exists
    #   and also if the user password matches the password in the db
    if @user && @user.password == params[:password]
      # this line signs a user in
      session[:user_id] = @user.id
  
      # lets the user know that something is wrong
      # redirects to the home page
      redirect "/mainpage/#{session[:user_id]}"
    else
      # lets the user know that something is wrong
  
      # if user does not exist or password does not match then
      #   redirect the user to the sign in page
      redirect "/dixit/sign_in"
    end
  end
  
  # displays signup form
  #   with fields for relevant user information like:
  #   username, password
  get "/dixit/sign_up" do
    erb :sign_up, :layout => :layout_user
  end

  
  post "/dixit/sign_up" do
    @user = User.create(
      nickname: params[:nickname],
      username: params[:username],
      password: params[:password]
    )
  
    # this line does the signing in
    session[:user_id] = @user.id
  
    # lets the user know they have signed up  
    # assuming this page exists
    redirect "/mainpage/#{session[:user_id]}"
  end
  
  # when hitting this get path via a link
  #   it would reset the session user_id and redirect
  #   back to the homepage

  get "/dixit/sign_out" do
    # this is the line that signs a user out
    session[:user_id] = nil
  
    # lets the user know they have signed out
    # flash[:info] = "You have been signed out"
    redirect "/"
  end
  
  
  get '/users/:id/edit' do 
    if session[:user_id] == params[:id]
      #Access thier user profile edit page
    else
      #Redirect them and tell them they do not have access to edit other peoples profile pages
    end
  end


get "/mainpage/:id" do 
    # @specific_user = User.find(params[:id])
    # @specific_user = User.find(session[:user_id])
    erb :dixit_skyling, :layout => :layout_page_for_user
end

get "/dixit/:user_id/blog" do 
    @specific_user = User.find(params[:user_id])
    @all_posts_of_specific_user = Post.where(user_id: @specific_user.id).order(:id)
    erb :dixit_blog, :layout => :layout_blog
end

# @todo: remove id
get "/dixit/:id/friendlist" do 
    @all_users = User.all
    # @all_posts = Post.all
    
    erb :friendlist, :layout => :layout_friendlist
end

# @todo: remove id
get '/dixit/:id/create' do 
    @all_images = Visual.all
    @all_posts = Post.all
    erb :create_post, :layout => :layout_create_post
end

post '/dixit/post/new' do
    # @specific_user = User.find(session[:user_id])
    Post.create(
        title: params[:title], 
        date: params[:date], 
        text: params[:text],
        visual_x_position: 100,
        visual_y_position: 100,
        visual_id: params[:visual_id],
        user_id: @specific_user.id,

    )
    redirect "/dixit/#{session[:user_id]}/blog"
end

get '/dixit/posts/:id' do 
    @specific_post = Post.find(params[:id])
    # @specific_post_image = Visual.find(@specific_post.visual_id)
    # puts @specific_post.visual
    erb :specific_post, :layout => :layout_post
end

get '/dixit/friendlist/posts/:id' do 
    @specific_post = Post.find(params[:id])
    # @specific_post_image = Visual.find(@specific_post.visual_id)
    # puts @specific_post.visual
    erb :friendlist_specific_post, :layout => :layout_friend_post
end

get '/dixit/posts/:id/edit' do
    @specific_post = Post.find(params[:id])
    @all_images = Visual.all
    # @current_post.update(title: params[:title], date: params[:date], text: params[:text], visual_id: params[:visual_id] )
    erb :edit_post, :layout => :layout_post
end

put '/dixit/posts/:id' do 
    # @specific_user = User.find(session[:user_id])
    @specific_post = Post.find(params[:id])
    @specific_post.update(
        title: params[:title], 
        date: params[:date], 
        text: params[:text], 
        visual_id: params[:visual_id],
        user_id: @specific_user.id,
        # visual_x_position: params[:visual_x_position],
        # visual_y_position: params[:visual_y_position],
    )
    redirect "/dixit/posts/#{params[:id]}"
end

put '/dixit/posts/:id/update-coordinates' do 
    @specific_post = Post.find(params[:id])
    result = @specific_post.update(
        visual_x_position: params[:visual_x_position],
        visual_y_position: params[:visual_y_position],
    )
    {:result => params}.to_json
end

delete '/dixit/posts/:id' do
    @specific_post = Post.delete(params[:id])
    redirect "/dixit/#{session[:user_id]}/blog"
end

private

def get_current_user 
    User.find(session[:user_id])
end