
class UserController < ApplicationController
  
  get '/sign_up' do
    @user = User.new(params)
    erb :'user/sign_up'
  end

  post '/sign_up' do
    @user = User.new(params)
    if @user.save      
       session[:user_id]=@user.id
       redirect("/user/#{session[:user_id]}")
    elsif @user.errors.any?
      erb :'user/sign_up'
    end
  end

  get '/login' do
    if logged_in?
      redirect("/")
    else
      session.delete("login")
      if ! session[:login]
        session[:login]=1
      end

      erb :'user/login'
    end
    
  end

  post '/login' do
    if login_valid? == true
      redirect "/user/#{session[:user_id]}"
    else
      erb :'user/login'
    end

  end

  get '/user/:id' do
      if session[:user_id] && session[:user_id] == params[:id].to_i
        @user = User.find_by(id: session[:user_id])
        erb :'user/user'
      else
        redirect("/")
      end   
  end

  get '/logout' do
    session.clear
    redirect("/")
  end
end