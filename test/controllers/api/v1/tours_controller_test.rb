require "test_helper"

class Api::V1::ToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_tour = api_v1_tours(:one)
  end

  test "should get index" do
    get api_v1_tours_url, as: :json
    assert_response :success
  end

  test "should create api_v1_tour" do
    assert_difference("Api::V1::Tour.count") do
      post api_v1_tours_url, params: { api_v1_tour: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_tour" do
    get api_v1_tour_url(@api_v1_tour), as: :json
    assert_response :success
  end

  test "should update api_v1_tour" do
    patch api_v1_tour_url(@api_v1_tour), params: { api_v1_tour: {  } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_tour" do
    assert_difference("Api::V1::Tour.count", -1) do
      delete api_v1_tour_url(@api_v1_tour), as: :json
    end

    assert_response :no_content
  end
end
