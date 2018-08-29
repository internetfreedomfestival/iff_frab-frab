class Cfp::UsersController < ApplicationController
  layout 'signup'

  before_action :authenticate_user!, only: [:edit, :update]

  def new
    @form = SignUpForm.new
  end

  def create
    @form = SignUpForm.new(params['sign_up_form'])

    if @form.valid?
      person = Person.new(
        email: @form.email,
        email_confirm: @form.email_confirm,
        first_name: @form.first_name,
        last_name: @form.last_name,
        pgp_key: @form.pgp_key,
        gender: @form.gender,
        country_of_origin: @form.country_of_origin,
        group: @form.group,
        professional_background: @form.professional_background,
        other_background: @form.other_background,
        organization: @form.organization,
        project: @form.project,
        include_in_mailings: @form.include_in_mailings,
        invitation_to_mattermost: @form.invitation_to_mattermost
      )
      user = User.new(
        email: @form.email,
        password: @form.password,
        password_confirmation: @form.password_confirmation,
        person: person
      )
      conference = Conference.find_by_acronym(params[:conference_acronym])

      if user.save
        user.send_confirmation_instructions(conference)
        redirect_to new_cfp_session_path, notice: t(:"cfp.signed_up")
        return
      end
    end

    render action: 'new'
  end

  def edit
    @user = current_user
    render layout: 'cfp'
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to cfp_person_path, notice: t(:"cfp.updated")
    else
      render action: 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def person_params
    params.require(:user).require(:person_attributes).permit(:email_confirm, :first_name, :last_name, :pgp_key, :gender, :country_of_origin, :group, :professional_background, :other_background, :organization, :project, :include_in_mailings, :invitation_to_mattermost)
  end
end
