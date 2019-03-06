module Api
  module V1
    class LinksController < ActionController::API
      ERROR_DB_FAILED = 'Failed to connect to db'.freeze
      ERROR_INVALID_URL = 'Invalid Url'.freeze
      ERROR_LINK_NOT_FOUND = 'Link not found'.freeze
      SUCCESS = 'Success'.freeze

      # Creates a new link if the url doesn't exist yet in the system.
      # Otherwise, just return the existing link.
      #
      # @param [String] url The url to be pruned.
      def create
        normalized_url = Link.normalize_url(params[:url])
        if normalized_url.nil?
          render json: LinkResponse.new(ERROR_INVALID_URL, params[:code]), status: 422
        else
          begin
            link = Link.find_or_create(normalized_url, params[:type])
            render json: LinkResponse.new(SUCCESS, link.code), status: 200
          rescue => error
            render json: LinkResponse.new(ERROR_INVALID_URL, params[:code]), status: 500
          end
        end
      end

    end

    # Link wrapper class to contain the response
    # Temporary only
    class LinkResponse
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
