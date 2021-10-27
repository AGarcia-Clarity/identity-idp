class VendorOutageController < ApplicationController
  include VendorOutageConcern

  def new
    analytics.track_event(
      Analytics::VENDOR_OUTAGE,
      redirect_from: session.delete(:vendor_outage_redirect),
    )
    @message = outage_message
  end

  private

  def outage_message
    t('vendor_outage.phone.blocked') if outage?(:voice) || outage?(:sms)
  end
end
