require "test_helper"

class CatalogueControllerTest < ActionDispatch::IntegrationTest
  test "should get httpartyGet" do
    get catalogue_httpartyGet_url
    assert_response :success
  end
end
