class HistogramController < ApplicationController
  def query
    Streem::Search.new(histogram_params).perform
  end

  def histogram_params
    params.permit(:before, :after, :interval, :urls => [])
  end
end
