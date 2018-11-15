require 'rack-flash'

class LandmarksController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/landmarks' do
    @landmarks = Landmark.all
    erb :'/landmarks/index'
  end

  get '/landmarks/new' do
    erb :'/landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'/landmarks/show'
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])

    if @landmark
      erb :'/landmarks/edit'
    else
      redirect to ':/landmarks'
    end
  end

  post '/landmarks' do
    landmark_name = params["landmark"]["name"]
    landmark_year = params["landmark"]["year_completed"]

    if landmark_name
      @landmark = Landmark.new(name: landmark_name, year_completed: landmark_year)
    else
      @error_message = "You must enter a landmark name!"
      @landmarks = Landmark.all
      erb :'/figures/new'
    end

    @landmark.save
    flash[:message] = "Successfully created Landmark."
    redirect to "/landmarks/#{@landmark.id}"
  end

  patch '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    @landmark.name = params["landmark"]["name"]
    @landmark.year_completed = params["landmark"]["year_completed"]

    @landmark.save
    redirect to "/landmarks/#{@landmark.id}"
  end
end
