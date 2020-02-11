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

    def errors?
      
      if params[:car]
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
      else
        car = Car.new(params)
        params.any? [{ |(key, value)| value.size==0 }]

        if car.save && params[:make] && params[:make].size>0 && params[:model].size>0 && params[:year].size>0 
          @user=User.find_by(id: session[:user_id])
          car.user=@user
          @user.cars << car 
          nil
        else
          binding.pry
          car.errors.full_messages
        end

      end
    
    end

  end
end
