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

Note: This is temporarily added already due to Heroku deployment

## API Docs
|                           Endpoint                          | Description                                                                 |
|:-----------------------------------------------------------:|-----------------------------------------------------------------------------|
| GET /api/v1/stats/:code                                     | Returns the stats summary of the link assigned with the :code               |
| GET /api/v1/stats/:code/viewers                             | Returns a list of viewers that viewed the link                              |
| GET /api/v1/stats/:code/viewers_by_country?country=:country | Returns a list of viewers that viewed the link filtered by params[:country] |
| GET /api/v1/stats/:code/viewers_by_browser?browser=:browser | Returns a list of viewers that viewed the link filtered by params[:browser] |

## Testing

This app uses RSpec to test.

```
> rspec spec/
```

## Heroku Deployment
* Install heroku cli using brew by typing `brew install heroku/brew/heroku`
* Link your local git repo to heroku by typing `heroku git:remote -a <heroku app_name>`
* Login to heroku by typing `heroku login` and key in your credentials
* Create a db by typing `heroku addons:create heroku-postgresql`
* Migrate your database by typing `heroku run rake db:migrate`
* Deploy to heroku by typing `git push heroku master`

## Ideas for improvement

* Improve the stats api documentation and specs. Maybe use swagger or the Rspec api docs 
* Improve the generated code by using the actual url so that we can remove the url_digest column.
* Create a dockerfile 