class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def index
  end

end