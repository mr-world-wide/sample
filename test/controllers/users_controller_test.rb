require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create!(name: "Josh Cameron", email: "Josh@tanda.co", password: "stuff1234", password_confirmation: "stuff1234")
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should show user" do
    assert @user.valid?
    get user_path(@user.id)
    assert_response :success
    assert_template 'show'
  end

  test "View title should include users name" do
    get user_path(@user.id)
    assert_select "title", "#{@user.name} | Ruby on Rails Tutorial Sample App"
  end


end
