module Streem
  class Client
    class ElasticSearchError < StandardError; end

    def self.configure(url)
      @client = Elasticsearch::Client.new url: url
    end

    def self.search(index:, body:)
      begin
        @client.search index: index, body: body
      rescue => e
        raise ElasticSearchError, e.message
      end
    end
  end
end
