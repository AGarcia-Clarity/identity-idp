module VendorOutageConcern
  extend ActiveSupport::Concern

  ALL_VENDORS = [:voice, :sms]

  def redirect_if_outage(vendors:, from: nil)
    if all_vendor_outage?(vendors)
      session[:vendor_outage_redirect] = from
      redirect_to vendor_outage_url
    end
  end

  def any_vendor_outage?(vendors = ALL_VENDORS)
    vendors.any? { |vendor| vendor_outage?(vendor) }
  end

  def all_vendor_outage?(vendors = ALL_VENDORS)
    vendors.all? { |vendor| vendor_outage?(vendor) }
  end

  def vendor_outage?(vendor)
    raise ArgumentError, "invalid vendor #{vendor}" if !ALL_VENDORS.include?(vendor)
    IdentityConfig.store.send("vendor_status_#{vendor}") != :operational
  end
end
