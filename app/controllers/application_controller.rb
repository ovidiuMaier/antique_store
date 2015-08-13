class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :require_login
  include SessionsHelper

  private

      def not_authenticated
        flash[:warning] = 'You have to authenticate to access this page.'
        redirect_to log_in_path
      end

      def not_found
      #  message = "Foo with ID #{params[:id]} not found."
      #  logger.error message
        flash[:danger] = "Record not found"
        redirect_to root_url
      end
end
