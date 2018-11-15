require 'rack-flash'

class FiguresController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/new'
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

  post '/figures' do
    figure_name = params["figure"]["name"]
    title_name = params["title"]["name"]
    title_ids = params["figure"]["title_ids"]
    landmark_name = params["landmark"]["name"]
    landmark_year = params["landmark"]["year"]
    landmark_ids = params["figure"]["landmark_ids"]

    if figure_name
      @figure = Figure.new(name: figure_name)
      if title_name != ""
        @figure.titles << Title.find_or_create_by(name: title_name)
      end
      if landmark_name != ""
        @figure.landmarks << Landmark.find_or_create_by(name: landmark_name, year_completed: landmark_year)
      end
    else
      @error_message = "You must enter a figure name!"
      @titles = Title.all
      @landmarks = Landmark.all
      erb :'/figures/new'
    end
      if title_ids
        title_ids.each do |title_id|
          title = Title.find_by(id: title_id)
          if title
            @figure.titles << title
          end
        end
      else
        @error_message = "You must enter a title name!"
        @titles = Title.all
        @landmarks = Landmark.all
        erb :'/figures/new'
      end
      if landmark_ids
        landmark_ids.each do |landmark_id|
          landmark = Landmark.find_by(id: landmark_id)
          if landmark
            @figure.landmarks << landmark
          end
        end
      else
        @error_message = "You must enter a landmark name!"
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
    figure_name = params["figure"]["name"]
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
