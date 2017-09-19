class Cfp::EventsController < ApplicationController
  layout 'cfp'

  before_action :authenticate_user!, except: :confirm

  # GET /cfp/events
  # GET /cfp/events.xml
  def index
    authorize! :submit, Event

    @events = current_user.person.events
    @events.map(&:clean_event_attributes!) unless @events.nil?

    respond_to do |format|
      format.html { redirect_to cfp_person_path }
      format.xml  { render xml: @events }
    end
  end

  # GET /cfp/events/1
  def show
    authorize! :submit, Event
    redirect_to(edit_cfp_event_path)
  end

  # GET /cfp/events/new
  def new
    @new = true
    @public_names = ""
    Person.all.each do |person|
      @public_names += person.public_name + ", "
    end
    @users = User.all
    person = Person.find_by(user_id: current_user.id)
    if auth_person_for_new_event?(person)
      flash[:alert] = "You must first fill out all required fields of your personal profile."
      return redirect_to cfp_person_path, flash: { error: t('cfp.complete_personal_profile') }
    end
    authorize! :submit, Event
    @event = Event.new(time_slots: @conference.default_timeslots)
    @event.recording_license = @conference.default_recording_license

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /cfp/events/1/edit
  def edit
    @edit = true
    @public_names = ""
    Person.all.each do |person|
      @public_names += person.public_name + ", "
    end
    authorize! :submit, Event
    @event = current_user.person.events.find(params[:id])
  end

  # POST /cfp/events
  def create
    authorize! :submit, Event
    @event = Event.new(event_params.merge(recording_license: @conference.default_recording_license))
    @event.conference = @conference
    @event.event_people << EventPerson.new(person: current_user.person, event_role: 'submitter')
    @event.event_people << EventPerson.new(person: current_user.person, event_role: 'speaker')

    respond_to do |format|
      if @event.save
        format.html { redirect_to(cfp_person_path, notice: t('cfp.event_created_notice')) }
      else
        flash[:alert] = "You must fill out all the required fields!"
        @new = true
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /cfp/events/1
  def update
    authorize! :submit, Event
    @event = current_user.person.events.readonly(false).find(params[:id])
    @event.recording_license = @event.conference.default_recording_license unless @event.recording_license

    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to(cfp_person_path, notice: t('cfp.event_updated_notice')) }
      else
        flash[:alert] = "You must fill out all the required fields!"
        @edit = true
        format.html { render action: 'edit' }
      end
    end
  end

  # Delete /cfp/events/1
  def destroy
    authorize! :submit, Event
    event = current_user.person.events.readonly(false).find(params[:id])

    respond_to do |format|
      if event.delete
        format.html { redirect_to(cfp_person_path, notice: "Your proposal: '#{event.title}' has been deleted") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def withdraw
    authorize! :submit, Event
    @event = current_user.person.events.find(params[:id], readonly: false)
    @event.withdraw!
    redirect_to(cfp_person_path, notice: t('cfp.event_withdrawn_notice'))
  end

  def confirm
    if params[:token]
      event_person = EventPerson.find_by_confirmation_token(params[:token])

      # Catch undefined method `person' for nil:NilClass exception if no confirmation token is found.
      if event_person.nil?
        return redirect_to cfp_root_path, flash: { error: t('cfp.no_confirmation_token') }
      end

      event_people = event_person.person.event_people.where(event_id: params[:id])
      login_as(event_person.person.user) if event_person.person.user
    else
      fail 'Unauthenticated' unless current_user
      event_people = current_user.person.event_people.where(event_id: params[:id])
    end
    event_people.each(&:confirm!)
    if current_user
      redirect_to cfp_person_path, notice: t('cfp.thanks_for_confirmation')
    else
      render layout: 'signup'
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :subtitle, :event_type, :time_slots, :language, :abstract, :description, :logo, :track_id, :submission_note, :tech_rider, :target_audience_experience, :desired_outcome, :skill_level, :iff_before, :travel_assistance, :other_presenters, { iff_before: [] }, :track,
      event_attachments_attributes: %i(id title attachment public _destroy),
      links_attributes: %i(id title url _destroy)
    )
  end

  def auth_person_for_new_event?(person)
    !person.valid? || person.professional_background == [""] || person.iff_before == [""] || person.country_of_origin.nil?
  end
end
