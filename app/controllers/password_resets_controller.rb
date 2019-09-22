class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset
      flash[:warning] = "#{@user.email} your new password has been emailed to you"
      redirect_to root_url
    else
      flash[:danger] = "Your email address could not be found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be Blank")
      render 'edit'
    elsif @user.update_attributes(user_params)
      login(@user)
      @user.update_attribute(:password_reset_digest, nil)
      flash[:success] = "Your password has been changed"
      redirect_to @user
    else
      render 'edit'
    end

  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? &&
      @user.authenticated?(:password_reset, params[:id])
      redirect_to root_url
      end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired. Please reset again"
      redirect_to new_password_reset_url
    end
  end
end
