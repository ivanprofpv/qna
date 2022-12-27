class SearchController < ApplicationController
  def index
    @search_result = SearchService.new(params[:query], params[:scope]).call
  end
end