class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  protected
  def success(details)
    @details = details
    render "shared/success"
  end

  def error(code, message, details)
    @error_code = code
    @error_message = message
    @error_details = details
    render "shared/error"
  end
end
