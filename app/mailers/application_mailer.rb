class ApplicationMailer < ActionMailer::Base
  before_action :logo_attach

  default from: "noreply@cktour.club"
  layout "mailer"

  private

  def logo_attach
    attachments.inline['logo.png'] = File.read((Rails.root.join('public', 'logo.png')))
  end
end
