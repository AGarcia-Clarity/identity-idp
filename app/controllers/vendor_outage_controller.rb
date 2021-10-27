class VendorOutageController < ApplicationController
  include VendorOutageConcern

  def new
    analytics.track_event(
      Analytics::VENDOR_OUTAGE,
      redirect_from: session.delete(:vendor_outage_redirect),
    )
    @message = outage_message
    @options = outage_options
  end

  private

  def outage_message
    if vendor_outage?(:voice) || vendor_outage?(:sms)
      if from_idv_phone?
        t('vendor_outage.phone.blocked.idv')
      else
        t('vendor_outage.phone.blocked.verify')
      end
    end
  end

  def outage_options
    options = [
      {
        text: t('vendor_outage.get_updates_on_status_page'),
        url: StatusPage.base_url,
        new_tab: true,
      },
      {
        text: t('idv.troubleshooting.options.contact_support', app_name: APP_NAME),
        url: MarketingSite.contact_url,
        new_tab: true,
      },
    ]

    if from_idv_phone? && gpo_letter_available?
      options.unshift(
        text: t('idv.troubleshooting.options.verify_by_mail'),
        url: idv_gpo_path,
      )
    end

    options
  end

  def from_idv_phone?
    params[:from] == 'idv_phone'
  end

  def gpo_letter_available?
    @_gpo_letter_available ||= FeatureManagement.enable_gpo_verification? &&
                               current_user &&
                               !Idv::GpoMail.new(current_user).mail_spammed?
  end
end
