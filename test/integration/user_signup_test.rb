require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "invalid sign up doesn't create new user" do
    get signup_path
    assert_no_difference 'User.count' do
     post signup_path, params: {user: { name: "Josh", email: "josh@tanda.co", password: "short", password_confirm: "long"}}
    end
  end

  test "valid user can sign up" do
    get signup_path
    assert_difference 'User.count' do
      post signup_path, params: {user: { name: "Josh", email: "josh1@tanda.co", password: "tanda1234", password_confirm: "tanda1234"}}
    end
    follow_redirect!
    assert_template 'users/show'
  end


end