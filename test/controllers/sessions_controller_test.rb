require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(name: "Josh", email:"josh@tanda.co", password: "tanda123", password_confirmation: "tanda123")
  end

  test "should get new" do
    get login_path
    assert_response :success
    assert_template 'sessions/new'
  end

end
