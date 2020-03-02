class CarController < ApplicationController
  get '/cars/new' do
    if logged_in?
      erb :'car/new'
    else
      redirect("/")
    end
  end

  post '/cars/new' do

    if create_errors?
      erb :'car/new' 
    else
      @car = Car.new(params)
      @car.user = User.find_by(id: session[:user_id])
      new_car_specs
      @car.save
      redirect("/car/#{@car.id}")
    end
  end

  get '/car/:id'do
  if logged_in?
    @car = current_user.cars.find_by(id: params[:id])
    if @car
      erb :'car/show'        
    else
      redirect("/user/#{current_user.id}")        
    end
  else
    redirect("/")
  end
end

  get '/car/:id/edit'do
  if logged_in?
    @car = current_user.cars.find_by(id: params[:id])
    if @car
      erb :'car/edit'      
    else
      redirect("/user/#{current_user.id}")        
    end
  else
    redirect("/")
  end
end
  
  delete '/:id/delete' do 
    if logged_in?
      car = Car.find_by(id: params[:id])
      car.destroy
      redirect("/user/#{current_user.id}")    
    else
      redirect("/")
    end
  end
  
  patch '/:id/edit' do
    @car = current_user.cars.find_by(id: params[:id])
    if update_messages
      erb :'car/edit'
    else
      redirect("/car/#{@car.id}")
    end
  end
end
