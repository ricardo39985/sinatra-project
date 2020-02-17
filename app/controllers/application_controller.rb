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

    def update_errors?
      # binding.pry
      @car = Car.find_by(id: params[:car])
      @car.update(make: params[:make]) if params[:make] && params[:make].size>0
      @car.update(model: params[:model]) if params[:model] && params[:model].size>0
      @car.update(year: params[:year]) if params[:year] && params[:year].size>0 
      if @car.errors.any?
        ActiveRecord::Rollback
        errors = @car.errors.full_messages  
        @car = Car.find_by(id: params[:car])
        errors                    
      else
        nil        
      end
    end

    def create_errors?
      # binding.pry
      if params.all? { |(key, value)| value.size>0 } && params.size > 2
        car = Car.new(params)
        if car.save
          nil
        else
          car.errors.full_messages
        end

      elsif params.size == 1
        nil        
      else
        ["All fields are required"]
      end
    end

    def login_valid?
      
      messsage = []
      # binding.pry
      if params.all? { |(key, value)| value.size>0 } && params.size>0
        user= User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          session[:user_id]=user.id
            true
        elsif user == nil
          "User not found"
        else
          "Password incorrect"
        end
      else
        "Enter Log In credentials"
      end      
    end
  end
  not_found do
    status 404
    redirect("/")
  end
end
