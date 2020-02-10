
class UserController < ApplicationController
  
  get '/sign_up' do
    erb :'user/sign_up'
  end

  post '/sign_up' do
    user = User.new(params)
    if user.save      
       session[:user_id]=user.id
       redirect("/user/#{session[:user_id]}")
    else
      erb :failure
    end
  end

  get '/login' do
    erb :'user/login'
  end

  post '/login' do

    user=User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/user/#{session[:user_id]}"
    else
      erb :failure
    end
  end

  get '/user/:id' do
      if session[:user_id] && session[:user_id] == params[:id].to_i
        @user = User.find_by(id: session[:user_id])
        erb :'user/user'
      else
        erb :failure
      end
   
  end
end