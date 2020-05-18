require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "Helper title creates title" do
  assert_equal full_title("Contact"), "Contact | Daoboard: The roundabout way to getting things done"
  end

end