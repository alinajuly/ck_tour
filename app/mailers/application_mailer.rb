class ApplicationMailer < ActionMailer::Base
  before_action :logo_attach

  default from: "noreply@cktour.club"
  layout "mailer"

  private

  def logo_attach
    attachments.inline['logo.svg'] = File.read((Rails.root.join('public', 'logo.svg')))
  end
end
