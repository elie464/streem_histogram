require 'rails_helper'

RSpec.describe Streem::Client do
  subject { Class.new(Streem::Client) }

  describe ".search" do
    let(:url) { "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615" }
    let(:body) do
      {
        "query" => {
          "bool" => {
            "must" => [
              {
                "terms" => {
                  "page_url" => [url]
                }
              },
              {
                "range" => {
                  "derived_tstamp" => {
                    "from" => "1496275200000",
                    "to" => "1496304000000"
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
              "interval" => "15m"
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
      }
    end

    context "no error" do
      it "sends search request to elastic search" do
        stub_request(:get, "http://test.es.streem.com.au:9200/events/_search").
          with(
            body: "{\"query\":{\"bool\":{\"must\":[{\"terms\":{\"page_url\":[\"#{url}\"]}},{\"range\":{\"derived_tstamp\":{\"from\":\"1496275200000\",\"to\":\"1496304000000\"}}}]}},\"aggs\":{\"time\":{\"date_histogram\":{\"field\":\"derived_tstamp\",\"interval\":\"15m\"},\"aggs\":{\"url\":{\"terms\":{\"field\":\"page_url\"}}}}}}",
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'Basic ZWxhc3RpYzpzdHJlZW0=',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v0.15.2'
            })


        subject.configure(ENV['STREEM_ELASTIC_SEARCH_URL'])
        expect(subject.instance_variable_get(:@client)).to receive(:search).with(index: 'events', body: body)
        subject.search(index: 'events', body: body)
      end
    end

    context "elastic search error" do
      it "throws error" do
        stub_request(:get, "http://test.es.streem.com.au:9200/events/_search").
          with(
            body: "{\"query\":{\"bool\":{\"must\":[{\"terms\":{\"page_url\":[\"#{url}\"]}},{\"range\":{\"derived_tstamp\":{\"from\":\"1496275200000\",\"to\":\"1496304000000\"}}}]}},\"aggs\":{\"time\":{\"date_histogram\":{\"field\":\"derived_tstamp\",\"interval\":\"15m\"},\"aggs\":{\"url\":{\"terms\":{\"field\":\"page_url\"}}}}}}",
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'Basic ZWxhc3RpYzpzdHJlZW0=',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 500, body: "error", headers: {})


        subject.configure(ENV['STREEM_ELASTIC_SEARCH_URL'])
        expect{subject.search(index: 'events', body: body)}.to raise_error(Streem::Client::ElasticSearchError)
      end
    end
  end
end