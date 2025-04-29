AdminUser.create!(first_name: "Admin", last_name: "User", email: 'admin@example.com', password: 'password', password_confirmation: 'password')
%w[super_admin admin developer new_user].each do |role|
  Role.create!(name: role)
end
AdminUser.first.add_role :super_admin

User.create!(first_name: "User", last_name: "User", email: 'user@example.com', password: 'password', password_confirmation: 'password')


restaurant = Restaurant.create(name: "Lumbre", slogan: "Finca a la mesa", hero_text: "The Wild Garden is a restaurant that serves a mix of locally foraged greens, pickled beet and carrot, strawberry, goat cheese with a lemon-lavender vinaigrette.", about_text: "The Wild Garden is a restaurant that serves a mix of locally foraged greens, pickled beet and carrot, strawberry, goat cheese with a lemon-lavender vinaigrette.")

restaurant.socials.create(name: "Facebook", url: "https://www.facebook.com/lumbreyhumo/#", icon: "facebook.svg")
restaurant.socials.create(name: "Instagram", url: "https://www.instagram.com/lumbreyhumo/#", icon: "instagram.svg")

restaurant.addresses.create(label: "Restaurant Address", address: "Insurgentes 333, Atotonilco, 37839 El Cortijo, Gto., Mexico", url: "https://maps.app.goo.gl/b1C6RbjRpvyDmy9P9", active: true)
restaurant.addresses.create(label: "Restaurant Embedded Map", address: "Insurgentes 333, Atotonilco, 37839 El Cortijo, Gto., Mexico", url: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.8575114487126!2d-100.79714987216299!3d20.998348080643435!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x842b4faceaace155%3A0x218cf49020306a74!2sLumbre!5e0!3m2!1sen!2sus!4v1745355688478!5m2!1sen!2sus", active: true)

restaurant.phones.create(label: "Restaurant Phone WhatsApp", phone: "+52 415 109 9411", active: true)

restaurant.emails.create(label: "Restaurant Email", email: "lumbreyhumo@gmail.com", active: true)


# Create menu items
restaurant.products.create(
  category: "menu",
  title: "Wild Garden Salad",
  description: "A mix of locally foraged greens, pickled beet and carrot, strawberry, goat cheese with a lemon-lavender vinaigrette.",
  price: "180",
  options: "gf"
)
restaurant.products.create(
  category: "menu",
  title: "Fire Roasted Avocado",
  description: "Grilled avocado half served with smoked sea salt, lime wedges and cilantro crema. With burnt tortillas and house made salsa.",
  price: "155",
  options: "v,gf"
)
restaurant.products.create(
  category: "menu",
  title: "Fire-Grilled Seasonal Vegetables",
  description: "A rotating selection of seasonal farm vegetables, flame-grilled with chimichurri and served with a creamy cashew ranch dressing.",
  price: "160",
  options: "v,gf"
)
restaurant.products.create(
  category: "menu",
  title: "Focaccia Margherita Pizza",
  description: "House-made focaccia topped with San Marzano tomato sauce, mozzarella, and basil.",
  price: "240",
  options: "vo"
)
restaurant.products.create(
  category: "menu",
  title: "Grilled Mushroom Trio",
  description: "Wild mushrooms seasonally. Portobello, oyster, and shiitake mushrooms marinated in herbs and garlic, grilled over an open flame, and finished with a tamari-maple glaze. Served with house made focaccia.",
  price: "250",
  options: "v,gf"
)
restaurant.products.create(
  category: "menu",
  title: "Crispy Baby Potatoes",
  description: "Baby potatoes, oven roasted and finished in rosemary-garlic oil with flaky sea salt.",
  price: "170",
  options: "v,gf"
)
restaurant.products.create(
  category: "menu",
  title: "Roasted Beets with Jocoque & Pistachios",
  description: "Slow-roasted beet over a bed of tangy pink peppercorn jocoque cheese, topped with toasted pistachios, balsamic reduction and fresh dill.",
  price: "180",
  options: "ov,gf"
)
restaurant.products.create(
  category: "menu",
  title: "Esquites dip with Roasted Chile & Epazote",
  description: "Fire-roasted corn off the cob, tossed with house-made crema, cotija cheese, epazote, and chile-lime seasoning.",
  price: "170",
  options: "vo,gf"
)
restaurant.products.create(
  category: "menu",
  title: "24-Hour Short Rib \"Al Carbón\"",
  description: "Grass-fed costilla de res, slow-cooked 24 hours, then finished with mezcal glaze. Served with fire-roasted sauce and grilled Vidalia onion.",
  price: "360",
  options: "gf"
)
restaurant.products.create(
  category: "menu",
  title: "Guajillo & Agave Chicken",
  description: "Locally raised free-range chicken, marinated in guajillo and mezcal brown butter, slow-cooked at 3 hours, then fire-seared. Finished with a smoky chile glaze.",
  price: "320",
  options: "gf"
)
restaurant.products.create(
  category: "menu",
  title: "Grass-Fed Primal Burger",
  description: "Our famous burger on house made focaccia. Farm-fresh greens, heirloom tomato, pickled red onions, cheddar cheese, aioli. Served with french fries.",
  price: "260",
  options: ""
)
restaurant.products.create(
  category: "menu",
  title: "Mushroom Walnut Burger",
  description: "House-made mushroom and walnut patty on focaccia with farm-fresh greens, heirloom tomato, pickled red onions, and aioli. Served with french fries.",
  price: "260",
  options: "v"
)
restaurant.products.create(
  category: "specialty-cocktails",
  title: "Cielo",
  description: "El Tinieblo Joven with Clarified Guava, Lime, Star Anise and Fennel with Blue Spirulina Ice Sphere.",
  price: "200"
)
restaurant.products.create(
  category: "specialty-cocktails",
  title: "Solar",
  description: "El Tinieblo Reposado, Pineapple, Ginger, Lime, Mint with Turmeric Coconut Foam.",
  price: "220"
)
restaurant.products.create(
  category: "specialty-cocktails",
  title: "Tierra",
  description: "El Tinieblo Añejo, Campari, Vermouth Rosso.",
  price: "250"
)
restaurant.products.create(
  category: "non-alcoholic-specialties",
  title: "Chaga Colada",
  description: "Better than a Coke in every way. Chaga mushroom extract, vanilla simple and soda water.",
  price: "80"
)
restaurant.products.create(
  category: "non-alcoholic-specialties",
  title: "Kombucha",
  description: "Healthy probiotic soda. Ask about our seasonal flavors.",
  price: "90"
)
restaurant.products.create(
  category: "non-alcoholic-specialties",
  title: "Lemonade",
  description: "Pineapple, Blue Guava, Orange.",
  price: "60"
)
restaurant.products.create(
  category: "non-alcoholic-specialties",
  title: "Alfalfa Agua Fresca",
  description: "Alfalfa juice grown on the Finca with lime and raw sugar.",
  price: "60"
)

%w[menu specialty-cocktails non-alcoholic-specialties].each_with_index do |category, index|
  range = (index + 1..index + 5)
  range.each do |i|
    Todo.create!(category: category, name: "Todo Item #{i} - #{category}")
  end
end


%w[
  sign_in
  sign_up
  enable_weekly_deals
  enable_subscribe
  enable_meet_the_team
  enable_gallery
  enable_testimonials
].each do |feature|
  Flipper.disable(feature)
end


Schedule.create!(scheduleable_id: AdminUser.first.id, scheduleable_type: "AdminUser", name: "Appointment Availability", active: true, capacity: 3, exclude_lunch_time: false, beginning_of_week: "monday", time_zone: "Mountain Time (US & Canada)")

Schedule.first.rules.create!(name: "Open Time Rule MWF", rule_type: "inclusion", frequency_units: "IceCube::MinutelyRule", frequency: 15, days_of_week: [ "monday", "wednesday", "friday" ], start_date: Date.today, end_date: Date.today + 90.days, rule_hour_start: "08:00", rule_hour_end: "12:00")
Schedule.first.rules.create!(name: "Open Time Rule TTH", rule_type: "inclusion", frequency_units: "IceCube::MinutelyRule", frequency: 15, days_of_week: [ "tuesday", "thursday" ], start_date: Date.today, end_date: Date.today + 90.days, rule_hour_start: "17:15", rule_hour_end: "20:45")
