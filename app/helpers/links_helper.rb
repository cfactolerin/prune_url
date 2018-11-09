module LinksHelper

  # Returns the pruned url
  def pruned_url(link)
    return nil if link.nil?
    "#{root_url}#{link.code}"
  end

end
