class CarController < ApplicationController
  get '/cars/new' do
    redirect_if_not_logged_in
    erb :'car/new'
  end

  post '/cars/new' do
    redirect_if_not_logged_in
    if create_errors?
      erb :'car/new' 
    else
      @car = current_user.cars.new(params)
      new_car_specs
      @car.save
      redirect("/car/#{@car.id}")
    end
  end

  get '/car/:id'do
  redirect_if_not_logged_in
    set_car
    if @car
      erb :'car/show'        
    else
      redirect("/user/#{current_user.id}")        
    end
end

  get '/car/:id/edit'do
  redirect_if_not_logged_in
    set_car
    if @car
      erb :'car/edit'      
    else
      redirect("/user/#{current_user.id}")        
    end
end

  delete '/:id/delete' do
    redirect_if_not_logged_in 
    set_car
    if @car
      @car.destroy
      redirect("/user/#{current_user.id}")    
    else
      redirect("/")
    end
  end

  patch '/:id/edit' do
    if update_messages
      erb :'car/edit'
    else
      redirect("/car/#{@car.id}")
    end
  end

  private

  def set_car
    @car = current_user.cars.find_by(id: params[:id])    
  end

end
