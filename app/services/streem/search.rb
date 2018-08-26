module Streem
  class Search
    class InvalidParamsError < StandardError; end

    def initialize(params)
      @urls = params[:page_url]
      @before = params[:before]
      @after = params[:after]
      @interval = params[:interval]
    end

    def perform
      raise InvalidParamsError.new unless valid_params

      request = Streem::Requests::Events.new(@urls, @before, @after, @interval).build
      Streem::Client.search(index: 'events', body: request)
    end

    private

    def valid_params
      @before.present? && @after.present? && @interval.present? && @urls.present?
    end
  end
end
