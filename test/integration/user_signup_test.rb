require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid sign up doesn't create new user" do
    get signup_path
    assert_no_difference 'User.count' do
     post signup_path, params: {user: { name: "Example User", email: "user@example.com", password: "short", password_confirm: "long"}}
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid user can sign up with account activation" do
    get signup_path
    assert_difference 'User.count' do
      post signup_path, params: {user: { name: "Josh", email: "josh1@tanda.co", password: "tanda1234", password_confirm: "tanda1234"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    #try to login before activation
    log_in_as(user)
    assert_not is_logged_in?

    #invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?

    #invalid email, valid token
    get edit_account_activation_path(user.activation_token, email: 'fake@tanda.co')
    assert_not is_logged_in?

    #valid Activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end