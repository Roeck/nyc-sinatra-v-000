class LandmarksController < ApplicationController
  get '/landmarks' do
    @landmarks = Landmark.all
    erb :'/landmarks/index'
  end

  # before '/landmarks/:id' otherwise misinterprets param
  get '/landmarks/new' do
    erb :'/landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'/landmarks/show'
  end

  post '/landmarks/new' do
    landmark = Landmark.create(params[:landmark])
    redirect("/landmarks/#{landmark.id}")
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])
    erb :'/landmarks/edit'
  end

  patch '/landmarks/:id/edit' do
    landmark = Landmark.find(params[:id])
    landmark.update(params[:landmark])
    # cannot chain both lines because save method returns true or false, not a saved instance of object.
    redirect("/landmarks/#{landmark.id}")
  end

end
