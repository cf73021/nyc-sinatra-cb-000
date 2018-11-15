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

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all

    if @figure.titles
      @figure_titles = @figure.titles.name
    else
      @figure_titles = ""
    end

    if @figure.landmarks
      @figure_landmarks = @figure.landmarks.name
    else
      @figure_landmarks = ""
    end

    if @figure
      erb :'/figures/edit'
    else
      redirect to ':/figures'
    end
  end

  post '/landmarks' do
    landmark_name = params["landmark"]["name"]
    landmark_year = params["landmark"]["year"]

    if landmark_name
      @landmark = Landmark.new(name: figure_name)
    else
      @error_message = "You must enter a figure name!"
      @titles = Title.all
      @landmarks = Landmark.all
      erb :'/figures/new'
    end


    @figure.save
    flash[:message] = "Successfully created figure."
    redirect to "/figures/#{@figure.id}"
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
