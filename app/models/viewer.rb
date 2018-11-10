require 'digest'

# This class represents the viewers that uses the pruned url.
class Viewer < ApplicationRecord

  # Creates a viewer digest in MD5 using the ip and ua for faster searching
  def self.md5(ip, ua)
    Digest::MD5.new.update("#{ip}#{ua}").hexdigest
  end
end
