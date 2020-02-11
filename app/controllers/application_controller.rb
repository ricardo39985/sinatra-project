require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    enable :sessions
    set :session_secret, "secret_coffee"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    if session[:user_id]
      redirect("/user/#{session[:user_id]}") 
    else
      erb :home
    end
   
  end

  helpers do
    def logged_in?
      session[:user_id] && session[:user_id] == params[:id].to_i
    end
    def current_user
      User.find_by(id: session[:user_id])
      
    end

  end
end
