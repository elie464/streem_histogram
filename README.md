# Streem Histogram Service

This is the backend service for connecting to streem elasticsearch


## Setup
Please use port 3001 when testing with Streem React
```
bundle exec rails s -p 3001
```

## API

### GET /histogram

**parameters:**

* before - milliseconds (e.g. 1496275200000)
* after - milliseconds (e.g. 1496304000000)
* interval - string (e.g. 15m)
* page_url - array (e.g. "http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html")


## Testing

```
rspec
```