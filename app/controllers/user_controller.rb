
class UserController < ApplicationController
  
  get '/users/new' do
    if logged_in?
      redirect ("/user/#{current_user.id}")
    end
    @user = User.new
    erb :'user/new'
  end
  
  post '/new' do
    @user = User.new(params)
    if @user.save      
      session[:user_id]=@user.id
      success
      redirect("/user/#{@user.id}")
    else
      erb :'user/new'
    end
  end

  get '/login' do
    if logged_in?
      redirect("/")
    else
      @login_route = true
      session.delete("login")
      if ! session[:login]
        session[:login]=1
      end

      erb :'user/login'
    end
    
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if login_valid?
      session[:user_id] = @user.id
      redirect ("/user/#{current_user.id}")
    else
      # binding.pry
      erb :'user/login'
    end

  end

  get '/user/:id' do
    # binding.pry
      if logged_in? && params[:id].to_i == current_user.id
        # binding.pry
        erb :'user/index'
      elsif logged_in?
        redirect ("/user/#{current_user.id}")
      else
        redirect("/")
      end   
  end

  get '/logout' do
    session.clear
    redirect("/")
  end
end