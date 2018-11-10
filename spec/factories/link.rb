require 'base62-rb'
require 'digest'

FactoryBot.define do

  factory :link do
    code { Base62.encode(rand(10000000000000)) }
    original { "https://en.wikipedia.org/wiki/Main_Page" }
    url_digest { Digest::MD5.new.update("https://en.wikipedia.org/wiki/Main_Page").hexdigest }
  end

end

# Current schema
# t.string :code
# t.string :original, limit: 512
# t.string :url_digest
# t.index :code
# t.index :url_digest
# t.timestamps