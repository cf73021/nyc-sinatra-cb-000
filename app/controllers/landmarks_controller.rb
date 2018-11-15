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

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])
    @figure.name = params["figure"]["name"]
    title = params["title"]
    title_ids = params["figure"]["title_ids"]
    landmark = params["landmark"]
    landmark_ids = params["figure"]["landmark_ids"]

    if title_ids
      @figures.titles.clear
      title_ids.each do |id|
        t = Title.find(id)
        @figure.titles << t
      end
    end

    if !title["name"].empty?
      t = Title.create(:name => title["name"])
      @figure.titles << t
    end
    if landmark_ids
      @figure.landmarks.clear
      landmark_ids.each do |id|
        l = Landmark.find(id)
        @figure.landmarks << l
      end
    end
    if !landmark["name"].empty?
       l = Landmark.create(:name => landmark["name"])
       @figure.landmarks << l
    end
    @figure.save
    redirect to "/figures/#{@figure.id}"
  end
end
