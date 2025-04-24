class StaticController < ApplicationController
  before_action :set_restaurant

  def index
    @menu_items = @restaurant.products.active.category("menu")
    @specialty_cocktails = @restaurant.products.active.category("specialty-cocktails")
    @non_alcoholic_specialties = @restaurant.products.active.category("non-alcoholic-specialties")
    @socials = @restaurant.socials.active
    @restaurant_address = @restaurant.addresses.active.label("Restaurant Address").first
    @restaurant_embedded_map = @restaurant.addresses.active.label("Restaurant Embedded Map").first
    @restaurant_phone = @restaurant.phones.active.first.phone
    @restaurant_email = @restaurant.emails.active.first.email
    @events = @restaurant.events.active
    # flash[:notice] = "Successfully uploaded notice"
    # flash[:alert] = "Successfully uploaded alert"
    # flash[:error] = "Successfully uploaded error"
    # flash[:success] = "Successfully uploaded success"
    # flash[:danger] = "Successfully uploaded danger"
    # flash[:info] = "Successfully uploaded info"
    # flash[:warning] = "Successfully uploaded warning"
  end

  private

  def set_restaurant
    @restaurant = Restaurant.includes(:phones, :emails, :addresses, :socials, :events, :products).first
  end
end
