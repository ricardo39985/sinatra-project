require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    enable :sessions
    set :session_secret, "secret_coffee"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    if logged_in?
      redirect("/user/#{current_user.id}") 
    else
      erb :home
    end
   
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def new_car_specs
      @car.update(
      color: Faker::Vehicle.color ,
      transmission: Faker::Vehicle.transmission ,
      options: Faker::Vehicle.car_options.flatten.to_sentence,
      specs: Faker::Vehicle.standard_specs.flatten.to_sentence ,
      mileage:Faker::Vehicle.mileage(min: 50_000, max: 250_000)
    ) 
    end

    def success
      10.times do
        new_car = Car.new(
          make: Faker::Vehicle.manufacture,
          year: Faker::Vehicle.year,
          color: Faker::Vehicle.color ,
          transmission: Faker::Vehicle.transmission ,
          options: Faker::Vehicle.car_options.flatten.to_sentence,
          specs: Faker::Vehicle.standard_specs.flatten.to_sentence ,
          mileage:Faker::Vehicle.mileage(min: 50_000, max: 250_000)
        )
        new_car.model= Faker::Vehicle.model
        new_car.user = @user
        new_car.save
      end      
    end

    def login_errors
      errors = []
      if params.values.any? &:empty?
        errors << "All fields are required"
      elsif !@user
        errors << "User not found"  
      else      
        errors << "Password incorrect"        
      end
      errors     
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def update_messages
        @car.update(make: params[:make]) if params[:make] && params[:make].size>0
        @car.update(model: params[:model]) if params[:model] && params[:model].size>0
        @car.update(year: params[:year]) if params[:year] && params[:year].size>0
        if @car.save
            false
        else
          ActiveRecord::Rollback
          @car.errors.full_messages
        end
    end

    def create_errors?
      if params.all? { |(key, value)| value.size>0 } && params.size > 2
        car = Car.new(params)
        if car.save
          nil
        else
          car.errors.full_messages
        end

      elsif params.size == 0
        nil        
      else
        ["All fields are required"]
      end
    end

    def login_valid?
      if @user && @user.authenticate(params[:password])     
        true
      end 
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect("/")
      end
    end
  end

  not_found do
    status 404
    redirect("/")
  end
end
