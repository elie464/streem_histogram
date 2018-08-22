module Streem
  class Search
    def initialize(params)
      @urls = params[:urls]
      @before = params[:before]
      @after = params[:after]
      @interval = params[:interval]
    end

    def perform
      request = Streem::Requests::Events.new(@urls, @before, @after, @interval).build
      Streem::Client.search(index: 'events', body: request)
    end
  end
end
