require File.dirname(__FILE__) + '/test_helper.rb'

class FakeController < ActionController::Base

  def fake_action
    @posts = scopes_for(Post)
    render :inline => "<%= @posts.size %>"
  end

  protected

  def rescue_action(e)
    raise e
  end

end

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

class ConventionallyScopedNamesControllerTest < Test::Unit::TestCase
  load_schema

  def setup
    @fixtures = load_test_fixtures

    @controller = FakeController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def teardown
    #delete_test_fixtures
  end

  def test_scopes_defined
    assert_not_equal [], Post.scopes
  end

  def test_schema_and_fixtures_have_loaded_correctly
    assert_not_equal 0, Post.count
  end

  def test_for_no_params_scope_name
    get :fake_action
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_equal Post.count, assigns(:posts).size
  end

  def test_for_unknown_scope_name
    get :fake_action, :scopes => ["asdf"]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_equal Post.count, assigns(:posts).size
  end

  def test_for_published_scope_name
    get :fake_action, :scopes => ["published"]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_not_equal Post.count, assigns(:posts).size
    assert_equal Post.published.count, assigns(:posts).size
  end

  def test_for_published_or_draft_scope_name
    get :fake_action, :scopes => ["published_or_draft"]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_not_equal Post.count, assigns(:posts).size
    assert_equal Post.published_or_draft.count, assigns(:posts).size
  end

  def test_for_this_month_scope_name
    get :fake_action, :scopes => ["this_month"]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_not_equal [], assigns(:posts)
    assert_not_equal Post.count, assigns(:posts).size
    assert_equal Post.this_month.count, assigns(:posts).size
  end

  def test_for_published_and_this_month_scope_name
    get :fake_action, :scopes => ["this_month", "published"]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_not_equal [], assigns(:posts)
    assert assigns(:posts).include?(@foo_published_this_month)
    assert_equal Post.this_month.published.count, assigns(:posts).size
  end

  def test_for_in_the_last_month_with_title
    get :fake_action, :scopes => ["last_month", {"with_title" => "bar"}]
    assert_response(:success)
    assert_not_nil assigns(:posts)
    assert_not_equal [], assigns(:posts)
    assert assigns(:posts).include?(@bar_drafted_this_month)
    assert !assigns(:posts).include?(@bar_drafted_one_year_ago)
    assert !assigns(:posts).include?(@foo_published_this_month)
  end
end
