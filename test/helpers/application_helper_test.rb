require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "Helper title creates title" do
  assert_equal full_title("Contact"), "Contact | Bucket List App"
  end

end