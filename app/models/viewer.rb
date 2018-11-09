require 'digest'
class Viewer < ApplicationRecord

  def self.md5(ip, ua)
    Digest::MD5.new.update("#{ip}#{ua}").hexdigest
  end
end
