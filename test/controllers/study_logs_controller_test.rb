require "test_helper"

class StudyLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get study_logs_index_url
    assert_response :success
  end

  test "should get show" do
    get study_logs_show_url
    assert_response :success
  end

  test "should get new" do
    get study_logs_new_url
    assert_response :success
  end

  test "should get create" do
    get study_logs_create_url
    assert_response :success
  end

  test "should get edit" do
    get study_logs_edit_url
    assert_response :success
  end

  test "should get update" do
    get study_logs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get study_logs_destroy_url
    assert_response :success
  end
end
