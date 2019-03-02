class MailTemplatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :not_submitter!
  before_filter :find_conference

  def new
    @mail_template = MailTemplate.new
  end

  def edit
    @mail_template = @conference.mail_templates.find(params[:id])
  end

  def show
    @mail_template = @conference.mail_templates.find(params[:id])
    @send_filter_options = [
      ['All users in the platform', :all],
      ['All users holding ticket', :all_users_holding_ticket],
      ['All confirmed DIF users', :all_confirmed_dif_users],
      ["All DIF users (excluding confirmed)", :all_dif_users_excluding_confirmed],
      ["All confirmed events presenters", :all_confirmed_events_presenters],
      ["All rejected events presenters", :all_rejected_events_presenters],
      ["All users invited to get a ticket", :all_users_invited_to_get_a_ticket],
      ["All users who requested a ticket", :all_users_who_requested_a_ticket]
      # ,
      #
      # ['All speakers involved in all confirmed events',   :all_speakers_in_confirmed_events],
      # ['All speakers involved in all unconfirmed events', :all_speakers_in_unconfirmed_events],
      # ['All people with pending attendance', :all_pending_attendance_people],
      # ['All people with confirmed attendance', :all_confirmed_attendance_people],
      # ['All people with pending attendance BUT NO EMAIL SENT!!!!', :pending_but_no_email],
      # ['Test: Send to Pepe and Jamie only', :pepe_and_jamie],
      # ['Test: Only send to jamie', :just_jamie],
      # ['Test: Only send to test user', :just_test_user]
    ]
  end

  def send_mail
    @mail_template = @conference.mail_templates.find(params[:id])
    send_filter = params[:send_filter]

    # There's no feedback about job errors, so the users prefer to have the job done synchronously

    # if Rails.env.production?
    #   @mail_template.send_async(send_filter)
    #   redirect_to(@mail_template, notice: 'Mail deliveries queued.')
    # else
      @mail_template.send_sync(send_filter)
      redirect_to(@mail_template, notice: 'Mails delivered.')
    # end
  end

  def index
    result = search @conference.mail_templates, params
    @mail_templates = result.paginate page: params[:page]
  end

  def update
    @mail_template = @conference.mail_templates.find(params[:id])

    respond_to do |format|
      if @mail_template.update_attributes(mail_template_params)
        format.html { redirect_to(@mail_template, notice: 'Mail template was successfully updated.') }
        format.xml  { head :ok }
        format.js   { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @mail_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    t = MailTemplate.new(mail_template_params)
    @conference.mail_templates << t
    redirect_to(mail_templates_path, notice: 'Mail template was successfully added.')
  end

  def destroy
    @conference.mail_templates.find(params[:id]).destroy
    redirect_to(mail_templates_path, notice: 'Mail template was successfully destroyed.')
  end

  private

  def find_conference
    authorize! :administrate, @conference
  end

  def search(mail_templates, params)
    if params.key?(:term) and not params[:term].empty?
      term = params[:term]
      sort = begin
               params[:q][:s]
             rescue
               nil
             end
      @search = mail_templates.ransack(name_cont: term,
                                       subject_cont: term,
                                       content_cont: term,
                                       m: 'or',
                                       s: sort)
    else
      @search = mail_templates.ransack(params[:q])
    end

    @search.result(distinct: true)
  end

  def mail_template_params
    params.require(:mail_template).permit(:name, :subject, :content)
  end
end
