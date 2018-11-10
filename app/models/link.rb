require "digest"
require "addressable/uri"
require "base62-rb"

# This class represents a pruned URL that was requested in the system.
class Link < ApplicationRecord
  has_many :viewers

  validates :original, presence: true
  validates :code, presence: true, uniqueness: true
  validates :url_digest, presence: true, uniqueness: true

  class << self

    # Finds the existing link using the md5 digest of the url or create it if it doesn't exist
    # The url will be hashed using md5 to make the query faster rather than using the url
    #
    # @param [String] url The url to be pruned.
    def find_or_create(url)
      url_digest = md5(url)
      link = Link.find_by(url_digest: url_digest)
      if link.nil?
        link = Link.new(code: generate_code, original: url, url_digest: url_digest)

        # Loop until a unique code is generated.
        # This should mostly be done at most 2 rounds since the generate_code rarely collides
        loop do
          existing_link = Link.find_by(code: link.code)
          existing_link.present? ? link.code = generate_code : break
        end
        link.save
      end
      link
    end

    # Removes symbols, int'l chars, etc.
    # It will also add http by default if url doesn't include a scheme
    #
    # @param [String] original_url The url to be normalized
    def normalize_url(original_url)
      if original_url.nil? || original_url.strip.empty?
        nil
      else
        uri = Addressable::URI.heuristic_parse(original_url.strip).normalize
        uri.host.present? && /^http(s)?$/.match(uri.scheme) ? uri.to_s : nil
      end
    end

    private

    # Creates a MD5 hash for the url to help make the query faster
    #
    # @param [String] normalized_url The normalized url that will be encoded to MD5
    def md5(normalized_url)
      normalized_url.nil? ? "" : Digest::MD5.new.update(normalized_url).hexdigest
    end

    # Generate a random number between 9 to 99
    def pad_numbers
      rand(90) + 9
    end

    # Reduce the number so that it will give lesser characters
    GAP = 9_999_999_999.freeze

    # Returns a base62 string based on the current time.
    # Tested with 20 million codes and got no collision
    def generate_code
      base = Time.now.to_f.round(5).to_s.split('.').map(&:to_i)

      # random prevents collision when multiple links are added in the same millisecond
      random_days = (rand(100000) * 1.days.to_i)

      # Pad the current time in the front to ensure it won't have any collision in the near future.
      # Pad the current time in the back to add randomness
      magic_number = "#{pad_numbers}#{base.first + base.last + random_days}#{pad_numbers}".to_i - GAP
      Base62.encode(magic_number)
    end
  end


end
