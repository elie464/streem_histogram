require 'rails_helper'

describe 'Histogram Query Request', type: :request do
  describe 'GET /histogram' do
    context "invalid input" do
      it "throws error" do
        body =
          {
            "query" => {
              "bool" => {
                "must" => [
                  {
                    "terms" => {
                      "page_url" => nil
                    }
                  },
                  {
                    "range" => {
                      "derived_tstamp" => {
                        "from" => nil,
                        "to" => nil
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
                  "interval" => nil
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

        build_stub_request(path: "http://test.es.streem.com.au:9200/events/_search",
                           request_body: body.to_json,
                           status: 500,
                           response_body: "")

        get '/histogram', params: { hello: "hello" }
        expect(json_response['error']).to eq(I18n.t("errors.params"))
      end
    end

    context "valid input" do
      it "returns 200 with json" do
        body =
          {
            "query" => {
              "bool" => {
                "must" => [
                  {
                    "terms" => {
                      "page_url" => ["http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"]
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

        expected_output =
          {"took"=>39,
           "timed_out"=>false,
           "_shards"=>{"total"=>58, "successful"=>58, "skipped"=>0, "failed"=>0},
           "hits"=>
             {"total"=>327,
              "max_score"=>5.5073977,
              "hits"=>
                [{"_index"=>"events-20170601", "_type"=>"event", "_id"=>"2785a78d-b14d-4ae6-9286-8e5659c847f1", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"4b66bf0b-066f-4293-ad5a-0f646a880759", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"44c5e688-2e0a-4633-964e-33128942b05d", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"a65fed48-12a0-4ffa-82be-5d45bca3dd63", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"4e4ab1cf-72f0-4a3c-96c1-697375121938", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"e7602ce8-3e7f-43b1-8b48-71354bd5c377", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"88a8482f-224d-46d2-a31f-cf597d086d02", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"2fcb61e7-f997-452b-a3d9-2f5228367b2a", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"9efb1948-a2d9-4ad7-98b6-6434c4be2308", "_score"=>5.5073977},
                 {"_index"=>"events-20170601", "_type"=>"event", "_id"=>"558556ca-6c2a-4fdf-a403-93c6a35a09b7", "_score"=>5.5073977}]},
           "aggregations"=>
             {"time"=>
                {"buckets"=>
                   [{"key_as_string"=>"2017-06-01T00:00:00.000Z",
                     "key"=>1496275200000,
                     "doc_count"=>327,
                     "url"=>
                       {"doc_count_error_upper_bound"=>0,
                        "sum_other_doc_count"=>0,
                        "buckets"=>[{"key"=>"http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615", "doc_count"=>327}]}}]}}}

        build_stub_request(path: "http://test.es.streem.com.au:9200/events/_search",
                           request_body: body.to_json,
                           status: 200,
                           response_body: expected_output.to_json)

        get '/histogram', params: { before: '1496275200000', after:'1496304000000', interval: '15m', page_url: ['http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'] }
        expect(json_response).to eq(expected_output)
      end
    end
  end
end
