require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    @person = @user.person
    @conference = create(:conference)
    login_as(:admin)
  end

  def person_params
    @person.attributes.except(*%w(id avatar_content_type avatar_file_size avatar_updated_at avatar_file_name created_at updated_at user_id))
  end

  test 'should get index' do
    get :index, conference_acronym: @conference.acronym
    assert_response :redirect
  end

  test 'should get new' do
    get :new, conference_acronym: @conference.acronym
    assert_response :success
  end

  test 'should create person' do
    @person.email = generate(:email)

    assert_difference('Person.count') do
      post :create, person: person_params, conference_acronym: @conference.acronym
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test 'should show person' do
    get :show, id: @person.to_param, conference_acronym: @conference.acronym
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @person.to_param, conference_acronym: @conference.acronym
    assert_response :success
  end

  test 'should update person' do
    put :update, id: @person.to_param, person: person_params, conference_acronym: @conference.acronym
    assert_redirected_to person_path(assigns(:person))
  end

  test 'should destroy person' do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person.to_param, conference_acronym: @conference.acronym
    end

    assert_redirected_to(all_people_path)
  end

  test 'should invite persons to a conference' do
    post :send_invitation, id: @person.to_param, conference_acronym: @conference.acronym

    assert_equal(@person.email, Invited.first.email)
    assert_equal(@conference, Invited.first.conference)
  end

  test 'should allow person to submit event out of place' do
    post :allow_late_submissions, format: @person.to_param, conference_acronym: @conference.acronym

    @person.reload

    assert_equal(@person.late_event_submit, true)
  end

  test 'should accept invitations request' do
    post :accept_request, id: @person.to_param, conference_acronym: @conference.acronym

    assert_equal(@person.email, Invited.first.email)
    assert_equal(@conference, Invited.first.conference)
  end
end
