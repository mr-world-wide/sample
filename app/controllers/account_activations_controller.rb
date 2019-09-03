class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by_email(params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = "Your account has been activated"
      redirect_to user
    else
      flash[:danger] = "Invalid acitvation link"
      redirect_to root_url
    end
  end

  private


end
