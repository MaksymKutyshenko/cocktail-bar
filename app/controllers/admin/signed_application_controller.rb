class Admin::SignedApplicationController < Admin::AdminApplicationController

  before_action :signed_in_user, only: [:show, :edit, :update, :index, :destroy]

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to admin_signin_url, notice: 'Please sign_in'
    end
  end
end
