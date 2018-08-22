def build_stub_request(path:, request_body:, status:, response_body:)
  stub_request(:get, path).with(
    body: request_body,
    headers: {
      'Accept' => '*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v0.15.2',
      'Authorization'=>'Basic ZWxhc3RpYzpzdHJlZW0='
    }).to_return(
    status: status,
    body: response_body,
    headers: {
      'Content-Type' => 'application/json',
    })
end
