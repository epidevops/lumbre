class StaticController < ApplicationController
  before_action :set_restaurant
  before_action :set_store
  before_action :memoized_restaurant
  include TranslationsHelper

  def index
    # flash.now[:notice] = "Hello"
  end

  private

  def set_restaurant
    @restaurant ||= Restaurant.primary
      .includes(:phones, :emails, :addresses, :socials, :events, :products)
      .first
  end

  def set_store
    @store ||= Store.primary
      .includes(:events)
      .first
  end

  def memoized_restaurant
    @menu_items ||= @restaurant.products.active.category("menu")
    @specialty_cocktails ||= @restaurant.products.active.category("specialty-cocktails")
    @non_alcoholic_specialties ||= @restaurant.products.active.category("non-alcoholic-specialties")
    @socials ||= @restaurant.socials.active
    @restaurant_address ||= @restaurant.addresses.active.label("Restaurant Address").first
    @restaurant_embedded_map ||= @restaurant.addresses.active.label("Restaurant Embedded Map").first
    @restaurant_phone ||= @restaurant.phones.active.first.phone
    @restaurant_email ||= @restaurant.emails.active.first.email
    @events ||= @restaurant.events.active
    @restaurant_events ||= @restaurant.events.active
    @store_events ||= @store.events.active
  end
end
