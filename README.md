# Prune /pro͞on/

**Prune** came from the verb prune which means to cut back, trim, clip, remove.
This application will generate a minified version of a web address.

## Requirements

* Ruby 2.5.3
* Bundler 1.17.1
* Mysql


## Setup

**Clone the repository**
```
> git clone git@github.com:cfactolerin/prune_url.git
```

**Install dependencies**
```
# Install the bundler gem
> gem install bundler

# Install the required gems
> bundle install      
```

**Setup the Database**
```
# Update with database credentials
> cp config/database_sample.yml config/database.yml

# Create the database and tables
> rails db:setup 
```

**Setup MaxmindDB**

This applications uses MaxmindDB to resolve the countries and cities using the ip address.

Download the GeoLite2 City database [here](http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz) ([Full Site](https://dev.maxmind.com/geoip/geoip2/geolite2/))

Extract the file and copy `GeoLite2-City.mmdb` to `/lib`

## Testing

This app uses RSpec to test.

```
> rspec spec/
```