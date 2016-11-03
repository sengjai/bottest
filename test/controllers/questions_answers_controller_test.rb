require 'test_helper'

class QuestionsAnswersControllerTest < ActionController::TestCase
  test "should get create_story" do
    get :create_story
    assert_response :success
  end

end
