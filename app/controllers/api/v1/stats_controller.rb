# Stats Api Version 1
# This endpoint returns the recorded stats for the specified link
module Api
  module V1
    class StatsController < ActionController::API
      before_action :link

      ERROR_CODE_NOT_FOUND = "Code not found".freeze # Error message used if code is not found

      # This endpoint shows the stats summary of the specified link.
      # This is intended for creating graphs related to the viewer demographics of a link.
      # Can be accessed through the link /api/v1/stats/:code
      #
      # @param [String] code The generated code when the link has been pruned.
      def show
        browsers = {}
        os = {}
        countries = {}
        cities = {}

        # Iterate once and get all info together with the view counts
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

      # Returns the list of viewers that viewed the link using the specified code
      # Can be accessed through the link /api/v1/stats/:code/viewers
      #
      # @param [String] code The generated code when the link has been pruned.
      def viewers
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers
        })
        render json: stats
      end

      # Returns the list of viewers of the link filtered by the country parameter
      # Can be accessed through the link /api/v1/stats/:code/viewers_by_country?country=:country
      #
      # @param [String] code The generated code when the link has been pruned.
      # @param [String] country Filter the viewers by the specified country
      def viewers_by_country
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers.where(country: params[:country])
        })
        render json: stats
      end

      # Returns the list of viewers of the link filtered by the browser parameter
      # Can be accessed through the link /api/v1/stats/:code/viewers_by_browser?browser=:browser
      #
      # @param [String] code The generated code when the link has been pruned.
      # @param [String] browser Filter the viewers by the specified browser
      def viewers_by_browser
        stats = Stats.new("Success", params[:code], {
            viewers: @link.viewers.where(browser: params[:browser])
        })
        render json: stats
      end

      private

      # Retrieve the link using the :code parameter and short circuit it if the code is not found
      def link
        @link = Link.includes(:viewers).find_by(code: params[:code])
        if @link.nil?
          render json: Stats.new(ERROR_CODE_NOT_FOUND, params[:code]), status: 404
        end
      end

      # Stats wrapper class to contain the response
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

