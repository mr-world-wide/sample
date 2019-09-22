require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:josh)
  end

  test "user can reset passwords" do
    get new_password_reset_path
    assert_template "password_resets/new"
    #test invalid email
    post password_resets_path, params: { password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template "password_resets/new"
    #valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.password_reset_digest, @user.reload.password_reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    #password reset form
    user = assigns(:user)

    #wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # Incactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # right email,wrong token
    get edit_password_reset_path('wrongtoken', email: user.email)
    assert_redirected_to root_url
    # right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password, password confimration
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobar',
                            password_confirmation: 'foobaz'}}
    assert_select 'div#error_explanation'

    # empty password
    # Invalid password, password confimration
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: '',
                            password_confirmation: ''}}
    assert_select 'div#error_explanation'
    # Valid password & Confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'hellojosh',
                            password_confirmation: 'hellojosh'}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: {password_reset: {email: @user.email}}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: 'hellojosh',
                            password_confirmation: 'hellojosh'}}
    assert_response :redirect
    follow_redirect!
    assert_match "expired", response.body


  end
end
