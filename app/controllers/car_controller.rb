class CarController < ApplicationController
  get '/:id/create_car' do
    erb :'car/create'
  end
  post '/create_car' do
    car = Car.new(params)
    if car.save
      @user=User.find_by(id: session[:user_id])
      car.user=@user
      @user.cars << car
      redirect("/#{session[:user_id]}/all_cars")
      
    else
      erb :failure
    end
  end

  get '/:id/all_cars' do

    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'car/view_all'

    else
      erb :failure
    end
  end

  get '/:id/delete' do
    if logged_in?
      erb :'car/delete'
      
    else
      erb :failure
    end
  end
  delete '/:id/delete' do    
    if logged_in?
      params[:cars].each do |ids|
        car = Car.find_by(id: ids)
        car.destroy  
             
      end 
      redirect("#{session[:user_id]}/delete")     
    else
      erb :failure
    end
  end
  get '/:id/edit' do
    if logged_in?
      erb :'car/select'
    else
      erb :failure
    end
  end

  get '/:id/:car/modify' do
    binding.pry
    if logged_in?
     @car = Car.find_by(id: params[:car])
      erb :'car/edit'
    else
      
    end
    
  end
  patch '/:car/edit' do
    @car = Car.find_by(id: paams[:car])
    params.each do |k, v|
      k != nil ? @car.update(k v) : nil
            
    end
    binding.pry
  end
end