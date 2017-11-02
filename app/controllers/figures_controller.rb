class FiguresController < ApplicationController
  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    erb :'/figures/new'
  end

  # post '/figures/new' do
  #   # {"figure"=>{"name"=>"Jon", "title_ids"=>["1"], "landmark_ids"=>["1","4"]}, "title"=>{"name"=>"Master Jedi"}, "landmark"=>{"name"=>"Waza Stadium"}}
  #   figure = Figure.create(params[:figure])
  #   figure.titles << Title.new(params[:title]) unless params[:title][:name].empty?
  #   figure.landmarks << Landmark.new(params[:landmark]) unless params[:landmark][:name].empty?
  #   # idea: find_or_create_by / find_or_initialize_by better than build to prevent duplicates ?
  #   redirect("/figures/#{figure.id}")
  # end

  post '/figures/new' do
    # {"figure"=>{"name"=>"Jon", "title_ids"=>["1"], "landmark_ids"=>["1","4"]}, "title"=>{"name"=>"Master Jedi"}, "landmark"=>{"name"=>"Waza Stadium"}}
    figure = Figure.new(params[:figure])
    figure.titles.build(params[:title]) unless params[:title][:name].empty?
    figure.landmarks.build(params[:landmark]) unless params[:landmark][:name].empty?
    figure.save
    # idea: find_or_create_by / find_or_initialize_by better than build to prevent duplicates ?
    redirect("/figures/#{figure.id}")
  end

  get '/figures/:id' do
    @figure = Figure.find_by(id: params[:id])
    @titles = @figure.titles
    @landmarks = @figure.landmarks
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find_by(id: params[:id])
    @titles = @figure.titles
    @landmarks = @figure.landmarks
    erb :'/figures/edit'
  end

  patch '/figures/:id/edit' do
    figure = Figure.find_by(id: params[:id])
    # {"_method"=>"PATCH", "figure"=>{"name"=>"Jango Fett", "title_ids"=>["4"], "landmark_ids"=>["11"]}, "title"=>{"name"=>"Crazy Guy"}, "landmark"=>{"name"=>"Fett des mers"}, "splat"=>[], "captures"=>["9"], "id"=>"9"}
    figure.assign_attributes(params[:figure])
    figure.titles.find_or_initialize_by(name: params[:title][:name]) unless params[:title][:name].empty?
    figure.landmarks.find_or_initialize_by(name: params[:landmark][:name]) unless params[:landmark][:name].empty?
    figure.save
    # try to hit the db the least you can does that matter ? the same number of calls are necessary
    redirect("/figures/#{params[:id]}")
  end

end
