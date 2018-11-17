require "digest"
require "base62-rb"
module CodeGenerator
  MD5 = "md5".freeze
  SHA = "sha1".freeze

  def self.generate(type)
    case type
    when MD5
      Digest::MD5.new.update(base_generated_string.to_s).hexdigest[0..8]
    when SHA
      Digest::SHA1.new.update(base_generated_string.to_s).hexdigest[0..8]
    else
      Base62.encode(base_generated_string)
    end
  end

  private

  def self.base_generated_string
    base = Time.now.to_f.round(5).to_s.split('.').map(&:to_i)
    # random prevents collision when multiple links are added in the same millisecond
    random_days = (rand(100000) * 1.days.to_i)

    # Pad the current time in the front to ensure it won't have any collision in the near future.
    # Pad the current time in the back to add randomness
    "#{pad_numbers}#{base.first + base.last + random_days}#{pad_numbers}".to_i - GAP
  end

  # Generate a random number between 9 to 99
  def self.pad_numbers
    rand(90) + 9
  end

  # Reduce the number so that it will give lesser characters
  GAP = 9_999_999_999.freeze
end