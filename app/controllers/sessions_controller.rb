class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login(@user)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or_ @user
    else
      flash.now[:danger] = "Wrong username or password"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url

  end


  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
