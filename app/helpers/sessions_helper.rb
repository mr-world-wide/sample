module SessionsHelper
# logs users in.
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  #remember users in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns true if the given user is the current user
  def current_user?(user)
    user == current_user
  end
  # redirect userot the url they were trying to access.
  def redirect_back_or_(default)
    redirect_to (session[:fowarding_url] || default)
    session.delete(:fowarding_url)
  end


   #store the url the user was trying to access
  def store_location
    session[:fowarding_url] = request.original_url if request.get?
  end



end

