class CarController < ApplicationController
  get '/create_car' do
    erb :'car/create'
  end
  post '/create_car' do
    binding.pry
    car = Car.new(params)
    if car.save
      @user=User.find_by(id: session[:user_id])
      car.user=@user
      @user.cars << car
      redirect("/#{session[:user_id]}/all_cars")


      
    else
      
    end
  end

  get '/:id/all_cars' do
    binding.pry
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'car/view_all'

    else
      erb :failure
    end
    
  end
end