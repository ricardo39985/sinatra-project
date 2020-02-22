class CarController < ApplicationController
  get '/cars/new' do
    if logged_in?
      erb :'car/create'
    else
      redirect("/")
    end
  end
  post '/cars/new' do

    if create_errors?
      erb :'car/create' 
    else
      car = Car.new(params)
      car.save
      car.user = User.find_by(id: session[:user_id])
      User.find_by(id: session[:user_id]).cars << car
      redirect("/user")
    end
    
  end

  get '/cars/delete' do
    if logged_in?
      erb :'car/delete'
      
    else
      redirect("/")
    end
  end

  delete '/delete' do 

    if logged_in?
      if params[:cars]
        params[:cars].each do |ids|
          car = Car.find_by(id: ids)
          car.destroy
        end
          redirect("/delete") 
      else  
        session[:error_message] = "Please make a selection or return home"
        erb :'car/delete'
      end          
    else
      redirect("/")
    end
  end
  
  get '/cars/select' do
    if logged_in?
      erb :'car/select'
    else
      redirect("/")
    end
  end

  get '/cars/:car/edit' do

    @car = current_user.cars.find_by(id: params[:car])
    if logged_in? && @car
      erb :'car/edit'
    else
      redirect("/")
    end
  end

  patch '/:car/edit' do
    params.delete(:_method)

    @car = current_user.cars.find_by(id: params[:car])
    if update_errors?
      erb :'car/edit'
    else
      redirect("/user")
    end
  end
end