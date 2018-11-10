# This job will record the viewers data and associate it with the Link asynchronously
class RecordStatsJob
  include SuckerPunch::Job

  # Set the number of workers that will process the queue
  workers 5

  # Set the maximum jobs allowed in the queue
  max_jobs 100

  # Performs the ip reverse loopkup and the UA parsing and record the results to the database
  #
  # @param [Link] link The Link object where the data will be associated
  # @param [String] ip The ip address of the requester
  # @param [String] ua The user agent of the requester
  def perform(link, ip, ua)
    ActiveRecord::Base.connection_pool.with_connection do
      viewer_hash = Viewer.md5(ip, ua)
      viewer = Viewer.find_by(viewer_digest: viewer_hash)

      # Increment the view count if the viewer is the same to save db space
      if viewer
        viewer.increment!(:view_count)
      else
        viewer = Viewer.new
        viewer.ip = ip
        viewer.ua = ua
        viewer.viewer_digest = viewer_hash

        geo = MaxMind.lookup(ip)
        if geo.found?
          viewer.city = geo.city.name
          viewer.country = geo.country.iso_code
        end

        user_agent = UserAgent.parse(ua)
        viewer.browser = user_agent.browser
        viewer.browser_version = user_agent.version
        viewer.os = user_agent.platform
        viewer.view_count = 1

        viewer.link_id = link.id
        viewer.save!
      end
    end
  end
end