class HistogramController < ApplicationController
  def query
    render json: Streem::Search.new(histogram_params).perform
  end

  def histogram_params
    params.permit(:before, :after, :interval, :page_url => [])
  end
end
