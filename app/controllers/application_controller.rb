class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def require_user
    return if logged_in?

    store_location
    redirect_to login_path, flash: { danger: 'Login required' }
  end
end
