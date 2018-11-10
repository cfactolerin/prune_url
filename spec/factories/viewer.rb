FactoryBot.define do

  factory :viewer do
    ip { "49.147.105.25" }
    browser { "Firefox" }
    browser_version { "63" }
    os { "Macintosh" }
    country { "PH" }
    city { "Cebu" }
    ua { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0) Gecko/20100101 Firefox/63.0" }
    viewer_digest { "51e4e8b7e6a9b48d97048bae111c31c4" }
    view_count { 1 }
  end

end

# Viewer schema
# t.string :ip
# t.string :browser
# t.string :browser_version
# t.string :os
# t.string :country
# t.string :city
# t.string :ua, limit: 512
# t.string :viewer_digest
# t.integer :view_count, default: 0
# t.belongs_to :link