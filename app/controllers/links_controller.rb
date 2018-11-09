class LinksController < ApplicationController

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

  def create
    normalized_url = Link.normalize_url(params[:url])
    if normalized_url.nil?
      flash[:error] = "Invalid URL"
      redirect_to root_path
    else
      link = Link.find_or_create(normalized_url)
      redirect_to root_path(code: link.code)
    end
  end

  def visit
    link = Link.find_by(code: params[:code])
    if link
      redirect_to link.original, status: :moved_permanently
    else
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end

end
