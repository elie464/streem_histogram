module Streem
  module Requests
    class Events
      def initialize(urls, before, after, interval)
        @urls = urls
        @before = before
        @after = after
        @interval = interval
      end

      def build
        {
          "query" => {
            "bool" => {
              "must" => [
                {
                  "terms" => {
                    "page_url" => @urls
                  }
                },
                {
                  "range" => {
                    "derived_tstamp" => {
                      "from" => @before,
                      "to" => @after
                    }
                  }
                }
              ]
            }
          },
          "aggs" => {
            "time" => {
              "date_histogram" => {
                "field" => "derived_tstamp",
                "interval" => @interval
              },
              "aggs" => {
                "url" => {
                  "terms" => {
                    "field" => "page_url"
                  }
                }
              }
            }
          }
        }.to_json
      end
    end
  end
end
