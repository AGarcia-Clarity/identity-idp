module VendorOutageConcern
  extend ActiveSupport::Concern

  ALL_VENDORS = [:voice, :sms]

  def redirect_if_outage(vendors:, from: nil)
    if all_outage?(vendors)
      session[:vendor_outage_redirect] = from
      redirect_to vendor_outage_url
    end
  end

  def any_outage?(vendors = ALL_VENDORS)
    vendors.any? { |vendor| outage?(vendor) }
  end

  def all_outage?(vendors = ALL_VENDORS)
    vendors.all? { |vendor| outage?(vendor) }
  end

  def outage?(vendor)
    raise ArgumentError, "invalid vendor #{vendor}" if !ALL_VENDORS.include?(vendor)
    IdentityConfig.store.send("vendor_status_#{vendor}") != :operational
  end
end
