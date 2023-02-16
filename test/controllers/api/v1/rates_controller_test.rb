require "test_helper"

class Api::V1::RatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_rate = api_v1_rates(:one)
  end

  test "should get index" do
    get api_v1_rates_url, as: :json
    assert_response :success
  end

  test "should create api_v1_rate" do
    assert_difference("Api::V1::Rate.count") do
      post api_v1_rates_url, params: { api_v1_rate: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_rate" do
    get api_v1_rate_url(@api_v1_rate), as: :json
    assert_response :success
  end

  test "should update api_v1_rate" do
    patch api_v1_rate_url(@api_v1_rate), params: { api_v1_rate: {  } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_rate" do
    assert_difference("Api::V1::Rate.count", -1) do
      delete api_v1_rate_url(@api_v1_rate), as: :json
    end

    assert_response :no_content
  end
end
