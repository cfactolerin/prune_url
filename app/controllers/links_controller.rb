class LinksController < ApplicationController

  ERROR_DB_CONNECTION = "Oooops something went wrong with our system. Please try again".freeze

  # Displays the main page of the app.
  # If a code is passed, the existing link will be displayed
  #
  # @param [String] code Code generated by the system to represent the url after being pruned.
  def index
    @link = Link.new
    if params[:code].present?
      link = Link.find_by(code: params[:code])
      if link.present?
        @link = link
      else
        flash[:error] = "Invalid Code"
      end
    end
  end

  # Creates a new link if the url doesn't exist yet in the system.
  # Otherwise, just return the existing link.
  #
  # @param [String] url The url to be pruned.
  def create
    normalized_url = Link.normalize_url(params[:url])
    if normalized_url.nil?
      flash[:error] = "Invalid URL"
      redirect_to root_path
    else
      begin
        link = Link.find_or_create(normalized_url, params[:type])
        redirect_to root_path(code: link.code)
      rescue => error
        flash[:error] = ERROR_DB_CONNECTION
        redirect_to root_path
      end
    end
  end

  # Redirects to the original url represented by the code.
  # This will also record the viewer's data when called.
  #
  # @param [String] code Code generated by the system to represent the url after being pruned.
  def visit
    link = Link.find_by(code: params[:code])
    if link
      RecordStatsJob.perform_async(link, request.remote_ip, request.user_agent)
      redirect_to link.original, status: :moved_permanently
    else
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end

end
