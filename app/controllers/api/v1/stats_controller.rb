module Api
  module V1
    class StatsController < ActionController::API
      before_action :link

      ERROR_CODE_NOT_FOUND = "Code not found".freeze

      def show
        browsers = {}
        os = {}
        countries = {}
        cities = {}

        @link.viewers.each do |viewer|
          browsers[viewer.browser] = (browsers[viewer.browser] || 0) + 1
          os[viewer.os] = (os[viewer.os] || 0) + 1
          countries[viewer.country] = (countries[viewer.country] || 0) + 1
          cities[viewer.city] = (cities[viewer.city] || 0) + 1
        end

        stats = Stats.new("Success", params[:code], {
            total_view_count: @link.viewers.sum(:view_count),
            unique_viewers: @link.viewers.size,
            browsers: browsers,
            os: os,
            countries: countries,
            cities: cities
        })
        render json: stats
      end

      def viewers
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers
        })
        render json: stats
      end

      def viewers_by_country
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers.where(country: params[:country])
        })
        render json: stats
      end

      def viewers_by_browser
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers.where(browser: params[:browser])
        })
        render json: stats
      end

      private

      def link
        @link = Link.includes(:viewers).find_by(code: params[:code])
        if @link.nil?
          render json: Stats.new(ERROR_CODE_NOT_FOUND, params[:code]), status: 404
        end
      end

      class Stats
        attr_accessor :api_version, :message, :code, :data

        def initialize(message, code, data=nil)
          @api_version = "v1"
          @message = message
          @code = code
          @data = data
        end
      end

    end
  end
end

