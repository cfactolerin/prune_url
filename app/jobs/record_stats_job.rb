class RecordStatsJob
  include SuckerPunch::Job
  workers 5
  max_jobs 100

  def perform(link, ip, ua)
    ActiveRecord::Base.connection_pool.with_connection do
      viewer_hash = Viewer.md5(ip, ua)
      viewer = Viewer.find_by(viewer_hash: viewer_hash)
      if viewer
        viewer.increment!(:view_count)
      else
        viewer = Viewer.new
        viewer.ip = ip
        viewer.ua = ua
        viewer.viewer_hash = viewer_hash

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