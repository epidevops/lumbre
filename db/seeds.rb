if Rails.env.development? then

  AdminUser.create!(first_name: "Admin", last_name: "User", email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  %w[super_admin admin developer new_user].each do |role|
    Role.create!(name: role)
  end
  AdminUser.first.add_role :super_admin

  User.create!(first_name: "User", last_name: "User", email: 'user@example.com', password: 'password', password_confirmation: 'password')


  restaurant = Restaurant.create(
    active: true,
    primary: true
  )

  I18n.available_locales.each do |locale|
    Mobility.with_locale(locale) do
      restaurant.update!(
        name: case locale
              when :en then "Lumbre"
              when :es then "Lumbre"
              when :fr then "Lumbre"
              when :de then "Lumbre"
              when :'pt-BR' then "Lumbre"
              when :'es-MX' then "Lumbre"
              end,
        slogan: case locale
                when :en then "Experience the warmth of authentic Mexican cuisine"
                when :es then "Experimenta el calor de la auténtica cocina mexicana"
                when :fr then "Découvrez la chaleur de la cuisine mexicaine authentique"
                when :de then "Erleben Sie die Wärme der authentischen mexikanischen Küche"
                when :'pt-BR' then "Experimente o calor da autêntica culinária mexicana"
                when :'es-MX' then "Experimenta el calor de la auténtica cocina mexicana"
                end,
        hero_text: case locale
                   when :en then "Welcome to Lumbre, where traditional Mexican flavors meet contemporary dining"
                   when :es then "Bienvenido a Lumbre, donde los sabores mexicanos tradicionales se encuentran con la gastronomía contemporánea"
                   when :fr then "Bienvenue chez Lumbre, où les saveurs mexicaines traditionnelles rencontrent la gastronomie contemporaine"
                   when :de then "Willkommen bei Lumbre, wo traditionelle mexikanische Aromen auf zeitgenössische Küche treffen"
                   when :'pt-BR' then "Bem-vindo ao Lumbre, onde os sabores mexicanos tradicionais se encontram com a gastronomia contemporânea"
                   when :'es-MX' then "Bienvenido a Lumbre, donde los sabores mexicanos tradicionales se encuentran con la gastronomía contemporánea"
                   end,
        about_text: case locale
                    when :en then "At Lumbre, we bring the authentic taste of Mexico to your table. Our chefs combine traditional recipes with modern techniques to create an unforgettable dining experience."
                    when :es then "En Lumbre, llevamos el sabor auténtico de México a tu mesa. Nuestros chefs combinan recetas tradicionales con técnicas modernas para crear una experiencia gastronómica inolvidable."
                    when :fr then "Chez Lumbre, nous apportons le goût authentique du Mexique à votre table. Nos chefs combinent des recettes traditionnelles avec des techniques modernes pour créer une expérience culinaire inoubliable."
                    when :de then "Bei Lumbre bringen wir den authentischen Geschmack Mexikos an Ihren Tisch. Unsere Köche kombinieren traditionelle Rezepte mit modernen Techniken, um ein unvergessliches kulinarisches Erlebnis zu schaffen."
                    when :'pt-BR' then "No Lumbre, trazemos o sabor autêntico do México para sua mesa. Nossos chefs combinam receitas tradicionais com técnicas modernas para criar uma experiência gastronômica inesquecível."
                    when :'es-MX' then "En Lumbre, llevamos el sabor auténtico de México a tu mesa. Nuestros chefs combinan recetas tradicionales con técnicas modernas para crear una experiencia gastronómica inolvidable."
                    end
      )
    end
  end

  store = Store.create(
    active: true,
    primary: true
  )

  I18n.available_locales.each do |locale|
    Mobility.with_locale(locale) do
      store.update!(
        name: case locale
              when :en then "Lumbre Cafe and Market"
              when :es then "Café y Mercado Lumbre"
              when :fr then "Café et Marché Lumbre"
              when :de then "Lumbre Café und Markt"
              when :'pt-BR' then "Café e Mercado Lumbre"
              when :'es-MX' then "Café y Mercado Lumbre"
              end,
        slogan: case locale
                when :en then "Your destination for authentic Mexican flavors and artisanal products"
                when :es then "Tu destino para sabores mexicanos auténticos y productos artesanales"
                when :fr then "Votre destination pour les saveurs mexicaines authentiques et les produits artisanaux"
                when :de then "Ihr Ziel für authentische mexikanische Aromen und handgefertigte Produkte"
                when :'pt-BR' then "Seu destino para sabores mexicanos autênticos e produtos artesanais"
                when :'es-MX' then "Tu destino para sabores mexicanos auténticos y productos artesanales"
                end
      )
    end
  end

  restaurant.socials.create!([
    { name: 'Facebook', url: 'https://facebook.com/lumbreyhumo/#', icon: 'facebook.svg', active: true },
    { name: 'Instagram', url: 'https://instagram.com/lumbreyhumo/#', icon: 'instagram.svg', active: true }
  ])

  restaurant.addresses.create!([
    { label: "Restaurant Address", address: "Insurgentes 333, Atotonilco, 37839 El Cortijo, Gto., Mexico", url: "https://maps.app.goo.gl/b1C6RbjRpvyDmy9P9", active: true },
    { label: "Restaurant Embedded Map", address: "Insurgentes 333, Atotonilco, 37839 El Cortijo, Gto., Mexico", url: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.8575114487126!2d-100.79714987216299!3d20.998348080643435!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x842b4faceaace155%3A0x218cf49020306a74!2sLumbre!5e0!3m2!1sen!2sus!4v1745355688478!5m2!1sen!2sus", active: true }
  ])

  restaurant.phones.create!([
    { label: "Restaurant Phone WhatsApp", phone: "+52 415 109 9411", active: true }
  ])

  restaurant.emails.create!([
    { label: 'General Email', email: 'lumbreyhumo@gmail.com', active: true }
  ])

  restaurant.events.create!([
    { label: 'Kitchen', start_day: 'Friday', end_day: 'Saturday', start_time: '1:00 PM', end_time: '9:00 PM', active: true },
    { label: 'Sunset Jazz', start_day: 'Friday', end_day: 'Friday', start_time: '6:00 PM', end_time: '8:00 PM', active: true },
    { label: 'Kitchen', start_day: 'Sunday', end_day: 'Sunday', start_time: '9:00 AM', end_time: '6:00 PM', active: true },
    { label: 'Brunch', start_day: 'Sunday', end_day: 'Sunday', start_time: '9:00 AM', end_time: '2:00 PM', active: true }
  ])

  store.events.create!([
    { label: 'Hours', start_day: 'Tuesday', end_day: 'Sunday', start_time: '9:00 AM', end_time: '5:00 PM', active: true }
  ])

  # Create menu items with translations
  menu_items = [
    {
      category: 'menu',
      translations: {
        en: {
          title: 'Wild Garden Salad',
          description: 'Fresh mixed greens with seasonal vegetables and house-made vinaigrette'
        },
        es: {
          title: 'Ensalada Silvestre',
          description: 'Verduras mixtas frescas con vegetales de temporada y vinagreta de la casa'
        },
        fr: {
          title: 'Salade Sauvage',
          description: 'Mélange de légumes frais avec des légumes de saison et vinaigrette maison'
        },
        de: {
          title: 'Wilde Gartensalate',
          description: 'Frischer gemischter Salat mit saisonalem Gemüse und hausgemachtem Vinaigrette'
        },
        'pt-BR': {
          title: 'Salada Silvestre',
          description: 'Verduras mistas frescas com vegetais da estação e vinagrete da casa'
        },
        'es-MX': {
          title: 'Ensalada Silvestre',
          description: 'Verduras mixtas frescas con vegetales de temporada y vinagreta de la casa'
        }
      },
      price: "180",
      options: "gf"
    },
    {
      category: 'menu',
      translations: {
        en: {
          title: 'Fire Roasted Avocado',
          description: 'Creamy avocado roasted to perfection with a touch of spice'
        },
        es: {
          title: 'Aguacate Asado al Fuego',
          description: 'Aguacate cremoso asado a la perfección con un toque de picante'
        },
        fr: {
          title: 'Avocat Rôti au Feu',
          description: 'Avocat crémeux rôti à la perfection avec une touche d\'épices'
        },
        de: {
          title: 'Feuer-Geröstete Avocado',
          description: 'Cremige Avocado perfekt geröstet mit einer Prise Gewürzen'
        },
        'pt-BR': {
          title: 'Abacate Assado no Fogo',
          description: 'Abacate cremoso assado à perfeição com um toque de tempero'
        },
        'es-MX': {
          title: 'Aguacate Asado al Fuego',
          description: 'Aguacate cremoso asado a la perfección con un toque de picante'
        }
      },
      price: "155",
      options: "v,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Fire-Grilled Seasonal Vegetables",
          description: "A rotating selection of seasonal farm vegetables, flame-grilled with chimichurri and served with a creamy cashew ranch dressing."
        },
        es: {
          title: "Verduras de Temporada a la Parrilla",
          description: "Una selección rotativa de verduras de temporada de la granja, a la parrilla con chimichurri y servidas con un aderezo cremoso de anacardos."
        },
        fr: {
          title: "Légumes de Saison Grillés au Feu",
          description: "Une sélection rotative de légumes de saison de la ferme, grillés à la flamme avec du chimichurri et servis avec une vinaigrette crémeuse aux noix de cajou."
        },
        de: {
          title: "Feuer-Gegrilltes Saisongemüse",
          description: "Eine wechselnde Auswahl an saisonalem Farmgemüse, flammen-gegrillt mit Chimichurri und serviert mit einem cremigen Cashew-Ranch-Dressing."
        },
        "pt-BR": {
          title: "Legumes da Estação Grelhados no Fogo",
          description: "Uma seleção rotativa de legumes da estação da fazenda, grelhados na chama com chimichurri e servidos com um molho cremoso de castanha de caju."
        },
        "es-MX": {
          title: "Verduras de Temporada a la Parilla",
          description: "Una selección rotativa de verduras de temporada de la granja, a la parrilla con chimichurri y servidas con un aderezo cremoso de anacardos."
        }
      },
      price: "160",
      options: "v,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Focaccia Margherita Pizza",
          description: "House-made focaccia topped with San Marzano tomato sauce, mozzarella, and basil."
        },
        es: {
          title: "Pizza Focaccia Margherita",
          description: "Focaccia casera cubierta con salsa de tomate San Marzano, mozzarella y albahaca."
        },
        fr: {
          title: "Pizza Focaccia Margherita",
          description: "Focaccia maison garnie de sauce tomate San Marzano, mozzarella et basilic."
        },
        de: {
          title: "Focaccia Margherita Pizza",
          description: "Hausgemachte Focaccia belegt mit San Marzano-Tomatensauce, Mozzarella und Basilikum."
        },
        "pt-BR": {
          title: "Pizza Focaccia Margherita",
          description: "Focaccia caseira coberta com molho de tomate San Marzano, mussarela e manjericão."
        },
        "es-MX": {
          title: "Pizza Focaccia Margherita",
          description: "Focaccia casera cubierta con salsa de tomate San Marzano, mozzarella y albahaca."
        }
      },
      price: "240",
      options: "vo"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Grilled Mushroom Trio",
          description: "Wild mushrooms seasonally. Portobello, oyster, and shiitake mushrooms marinated in herbs and garlic, grilled over an open flame, and finished with a tamari-maple glaze. Served with house made focaccia."
        },
        es: {
          title: "Trío de Hongos a la Parrilla",
          description: "Hongos silvestres de temporada. Hongos portobello, ostra y shiitake marinados en hierbas y ajo, a la parrilla sobre llama abierta y terminados con un glaseado de tamari y maple. Servidos con focaccia casera."
        },
        fr: {
          title: "Trio de Champignons Grillés",
          description: "Champignons sauvages de saison. Champignons portobello, pleurotes et shiitake marinés aux herbes et à l'ail, grillés sur flamme vive et finis avec un glaçage tamari-érable. Servis avec focaccia maison."
        },
        de: {
          title: "Gegrilltes Pilz-Trio",
          description: "Wilde Pilze saisonal. Portobello-, Austern- und Shiitake-Pilze mariniert in Kräutern und Knoblauch, über offener Flamme gegrillt und mit einer Tamari-Ahorn-Glasur abgeschlossen. Serviert mit hausgemachter Focaccia."
        },
        "pt-BR": {
          title: "Trio de Cogumelos Grelhados",
          description: "Cogumelos selvagens da estação. Cogumelos portobello, ostra e shiitake marinados em ervas e alho, grelhados sobre chama aberta e finalizados com um glacê de tamari e maple. Servidos com focaccia caseira."
        },
        "es-MX": {
          title: "Trío de Hongos a la Parilla",
          description: "Hongos silvestres de temporada. Hongos portobello, ostra y shiitake marinados en hierbas y ajo, a la parrilla sobre llama abierta y terminados con un glaseado de tamari y maple. Servidos con focaccia casera."
        }
      },
      price: "250",
      options: "v,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Crispy Baby Potatoes",
          description: "Baby potatoes, oven roasted and finished in rosemary-garlic oil with flaky sea salt."
        },
        es: {
          title: "Papas Bebé Crujientes",
          description: "Papas bebé, asadas al horno y terminadas en aceite de romero y ajo con sal marina escamosa."
        },
        fr: {
          title: "Pommes de Terre Bébé Croustillantes",
          description: "Pommes de terre bébé, rôties au four et finies dans une huile romarin-ail avec du sel marin en flocons."
        },
        de: {
          title: "Knusprige Baby-Kartoffeln",
          description: "Baby-Kartoffeln, im Ofen geröstet und in Rosmarin-Knoblauch-Öl mit flockigem Meersalz abgeschlossen."
        },
        "pt-BR": {
          title: "Batatas Baby Crocantes",
          description: "Batatas baby, assadas no forno e finalizadas em óleo de alecrim e alho com sal marinho em flocos."
        },
        "es-MX": {
          title: "Papas Bebé Crujientes",
          description: "Papas bebé, asadas al horno y terminadas en aceite de romero y ajo con sal marina escamosa."
        }
      },
      price: "170",
      options: "v,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Roasted Beets with Jocoque & Pistachios",
          description: "Slow-roasted beet over a bed of tangy pink peppercorn jocoque cheese, topped with toasted pistachios, balsamic reduction and fresh dill."
        },
        es: {
          title: "Remolachas Asadas con Jocoque y Pistachos",
          description: "Remolacha asada lentamente sobre una cama de queso jocoque con pimienta rosa, cubierta con pistachos tostados, reducción de balsámico y eneldo fresco."
        },
        fr: {
          title: "Betteraves Rôties au Jocoque et Pistaches",
          description: "Betterave rôtie lentement sur un lit de fromage jocoque au poivre rose, garnie de pistaches grillées, réduction de balsamique et aneth frais."
        },
        de: {
          title: "Gebackene Rote Bete mit Jocoque & Pistazien",
          description: "Langsam gebackene Rote Bete auf einem Bett aus würzigem rosa Pfefferkorn-Jocoque-Käse, garniert mit gerösteten Pistazien, Balsamico-Reduktion und frischem Dill."
        },
        "pt-BR": {
          title: "Beterrabas Assadas com Jocoque e Pistaches",
          description: "Beterraba assada lentamente sobre uma cama de queijo jocoque com pimenta rosa, coberta com pistaches tostados, redução de balsâmico e endro fresco."
        },
        "es-MX": {
          title: "Betabeles Asados con Jocoque y Pistaches",
          description: "Betabel asado lentamente sobre una cama de queso jocoque con pimienta rosa, cubierto con pistaches tostados, reducción de balsámico y eneldo fresco."
        }
      },
      price: "180",
      options: "ov,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Esquites dip with Roasted Chile & Epazote",
          description: "Fire-roasted corn off the cob, tossed with house-made crema, cotija cheese, epazote, and chile-lime seasoning."
        },
        es: {
          title: "Dip de Esquites con Chile Asado y Epazote",
          description: "Maíz asado al fuego desgranado, mezclado con crema casera, queso cotija, epazote y condimento de chile y limón."
        },
        fr: {
          title: "Trempette d'Esquites au Piment Rôti et Épazote",
          description: "Maïs grillé au feu détaché de l'épi, mélangé avec de la crème maison, du fromage cotija, de l'épazote et un assaisonnement piment-citron vert."
        },
        de: {
          title: "Esquites-Dip mit Gerösteter Chili & Epazote",
          description: "Feuer-gerösteter Mais vom Kolben, gemischt mit hausgemachter Crema, Cotija-Käse, Epazote und Chili-Limette-Gewürz."
        },
        "pt-BR": {
          title: "Molho de Esquites com Pimenta Assada e Epazote",
          description: "Milho assado no fogo desgranado, misturado com creme caseiro, queijo cotija, epazote e tempero de pimenta e limão."
        },
        "es-MX": {
          title: "Dip de Esquites con Chile Asado y Epazote",
          description: "Elote asado al fuego desgranado, mezclado con crema casera, queso cotija, epazote y condimento de chile y limón."
        }
      },
      price: "170",
      options: "vo,gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "24-Hour Short Rib \"Al Carbón\"",
          description: "Grass-fed costilla de res, slow-cooked 24 hours, then finished with mezcal glaze. Served with fire-roasted sauce and grilled Vidalia onion."
        },
        es: {
          title: "Costilla Corta de 24 Horas \"Al Carbón\"",
          description: "Costilla de res alimentada con pasto, cocinada lentamente durante 24 horas, luego terminada con glaseado de mezcal. Servida con salsa asada al fuego y cebolla Vidalia a la parrilla."
        },
        fr: {
          title: "Côte Courte de 24 Heures \"Al Carbón\"",
          description: "Côte de bœuf nourri à l'herbe, cuite lentement pendant 24 heures, puis finie avec un glaçage au mezcal. Servie avec une sauce grillée au feu et un oignon Vidalia grillé."
        },
        de: {
          title: "24-Stunden Short Rib \"Al Carbón\"",
          description: "Grasgefütterte Rinderrippe, 24 Stunden langsam gegart, dann mit Mezcal-Glasur abgeschlossen. Serviert mit feuer-gerösteter Sauce und gegrillter Vidalia-Zwiebel."
        },
        "pt-BR": {
          title: "Costela Curta de 24 Horas \"Al Carbón\"",
          description: "Costela de boi alimentada com capim, cozida lentamente por 24 horas, depois finalizada com glacê de mezcal. Servida com molho assado no fogo e cebola Vidalia grelhada."
        },
        "es-MX": {
          title: "Costilla Corta de 24 Horas \"Al Carbón\"",
          description: "Costilla de res alimentada con pasto, cocinada lentamente durante 24 horas, luego terminada con glaseado de mezcal. Servida con salsa asada al fuego y cebolla Vidalia a la parrilla."
        }
      },
      price: "360",
      options: "gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Guajillo & Agave Chicken",
          description: "Locally raised free-range chicken, marinated in guajillo and mezcal brown butter, slow-cooked at 3 hours, then fire-seared. Finished with a smoky chile glaze."
        },
        es: {
          title: "Pollo Guajillo y Agave",
          description: "Pollo de libre pastoreo criado localmente, marinado en mantequilla de guajillo y mezcal, cocinado lentamente durante 3 horas, luego sellado al fuego. Terminado con un glaseado ahumado de chile."
        },
        fr: {
          title: "Poulet Guajillo et Agave",
          description: "Poulet élevé en liberté localement, mariné dans du beurre brun au guajillo et mezcal, cuit lentement pendant 3 heures, puis saisi au feu. Fini avec un glaçage fumé au piment."
        },
        de: {
          title: "Guajillo & Agave Huhn",
          description: "Lokal aufgezogenes Freilandhuhn, mariniert in Guajillo- und Mezcal-Braunbutter, 3 Stunden langsam gegart, dann feuer-geschmort. Abgeschlossen mit einer rauchigen Chili-Glasur."
        },
        "pt-BR": {
          title: "Frango Guajillo e Agave",
          description: "Frango caipira criado localmente, marinado em manteiga de guajillo e mezcal, cozido lentamente por 3 horas, depois selado no fogo. Finalizado com um glacê defumado de pimenta."
        },
        "es-MX": {
          title: "Pollo Guajillo y Agave",
          description: "Pollo de libre pastoreo criado localmente, marinado en mantequilla de guajillo y mezcal, cocinado lentamente durante 3 horas, luego sellado al fuego. Terminado con un glaseado ahumado de chile."
        }
      },
      price: "320",
      options: "gf"
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Grass-Fed Primal Burger",
          description: "Our famous burger on house made focaccia. Farm-fresh greens, heirloom tomato, pickled red onions, cheddar cheese, aioli. Served with french fries."
        },
        es: {
          title: "Hamburguesa Primal de Res Alimentada con Pasto",
          description: "Nuestra famosa hamburguesa en focaccia casera. Verduras frescas de la granja, tomate heirloom, cebollas rojas encurtidas, queso cheddar, aioli. Servida con papas fritas."
        },
        fr: {
          title: "Burger Primal au Bœuf Nourri à l'Herbe",
          description: "Notre célèbre burger sur focaccia maison. Verdure fraîche de la ferme, tomate ancienne, oignons rouges marinés, fromage cheddar, aïoli. Servi avec des frites."
        },
        de: {
          title: "Grasgefütterter Primal Burger",
          description: "Unser berühmter Burger auf hausgemachter Focaccia. Frisches Farmgemüse, Erbstück-Tomate, eingelegte rote Zwiebeln, Cheddar-Käse, Aioli. Serviert mit Pommes frites."
        },
        "pt-BR": {
          title: "Hambúrguer Primal de Gado Alimentado com Capim",
          description: "Nosso famoso hambúrguer em focaccia caseira. Verduras frescas da fazenda, tomate heirloom, cebolas roxas em conserva, queijo cheddar, aioli. Servido com batatas fritas."
        },
        "es-MX": {
          title: "Hamburguesa Primal de Res Alimentada con Pasto",
          description: "Nuestra famosa hamburguesa en focaccia casera. Verduras frescas de la granja, tomate heirloom, cebollas rojas encurtidas, queso cheddar, aioli. Servida con papas fritas."
        }
      },
      price: "260",
      options: ""
    },
    {
      category: "menu",
      translations: {
        en: {
          title: "Mushroom Walnut Burger",
          description: "House-made mushroom and walnut patty on focaccia with farm-fresh greens, heirloom tomato, pickled red onions, and aioli. Served with french fries."
        },
        es: {
          title: "Hamburguesa de Hongos y Nueces",
          description: "Hamburguesa casera de hongos y nueces en focaccia con verduras frescas de la granja, tomate heirloom, cebollas rojas encurtidas y aioli. Servida con papas fritas."
        },
        fr: {
          title: "Burger aux Champignons et Noix",
          description: "Steak végétal maison aux champignons et noix sur focaccia avec verdure fraîche de la ferme, tomate ancienne, oignons rouges marinés et aïoli. Servi avec des frites."
        },
        de: {
          title: "Pilz-Walnuss Burger",
          description: "Hausgemachte Pilz- und Walnuss-Pattie auf Focaccia mit frischem Farmgemüse, Erbstück-Tomate, eingelegten roten Zwiebeln und Aioli. Serviert mit Pommes frites."
        },
        "pt-BR": {
          title: "Hambúrguer de Cogumelos e Nozes",
          description: "Hambúrguer caseiro de cogumelos e nozes em focaccia com verduras frescas da fazenda, tomate heirloom, cebolas roxas em conserva e aioli. Servido com batatas fritas."
        },
        "es-MX": {
          title: "Hamburguesa de Hongos y Nueces",
          description: "Hamburguesa casera de hongos y nueces en focaccia con verduras frescas de la granja, tomate heirloom, cebollas rojas encurtidas y aioli. Servida con papas fritas."
        }
      },
      price: "260",
      options: "v"
    },
    {
      category: "specialty-cocktails",
      translations: {
        en: {
          title: "Cielo",
          description: "El Tinieblo Joven with Clarified Guava, Lime, Star Anise and Fennel with Blue Spirulina Ice Sphere."
        },
        es: {
          title: "Cielo",
          description: "El Tinieblo Joven con Guayaba Clarificada, Lima, Anís Estrellado y Hinojo con Esfera de Hielo de Espirulina Azul."
        },
        fr: {
          title: "Cielo",
          description: "El Tinieblo Joven avec Goyave Clarifiée, Citron Vert, Anis Étoilé et Fenouil avec Sphère de Glace à la Spiruline Bleue."
        },
        de: {
          title: "Cielo",
          description: "El Tinieblo Joven mit Klarifizierter Guave, Limette, Sternanis und Fenchel mit Blauer Spirulina-Eiskugel."
        },
        "pt-BR": {
          title: "Cielo",
          description: "El Tinieblo Joven com Goiaba Clarificada, Limão, Anis Estrelado e Funcho com Esfera de Gelo de Espirulina Azul."
        },
        "es-MX": {
          title: "Cielo",
          description: "El Tinieblo Joven con Guayaba Clarificada, Lima, Anís Estrellado y Hinojo con Esfera de Hielo de Espirulina Azul."
        }
      },
      price: "200",
      options: ""
    },
    {
      category: "specialty-cocktails",
      translations: {
        en: {
          title: "Solar",
          description: "El Tinieblo Reposado, Pineapple, Ginger, Lime, Mint with Turmeric Coconut Foam."
        },
        es: {
          title: "Solar",
          description: "El Tinieblo Reposado, Piña, Jengibre, Lima, Menta con Espuma de Cúrcuma y Coco."
        },
        fr: {
          title: "Solar",
          description: "El Tinieblo Reposado, Ananas, Gingembre, Citron Vert, Menthe avec Mousse de Curcuma et Noix de Coco."
        },
        de: {
          title: "Solar",
          description: "El Tinieblo Reposado, Ananas, Ingwer, Limette, Minze mit Kurkuma-Kokos-Schaum."
        },
        "pt-BR": {
          title: "Solar",
          description: "El Tinieblo Reposado, Abacaxi, Gengibre, Limão, Hortelã com Espuma de Cúrcuma e Coco."
        },
        "es-MX": {
          title: "Solar",
          description: "El Tinieblo Reposado, Piña, Jengibre, Lima, Menta con Espuma de Cúrcuma y Coco."
        }
      },
      price: "220",
      options: ""
    },
    {
      category: "specialty-cocktails",
      translations: {
        en: {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        },
        es: {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        },
        fr: {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        },
        de: {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        },
        "pt-BR": {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        },
        "es-MX": {
          title: "Tierra",
          description: "El Tinieblo Añejo, Campari, Vermouth Rosso."
        }
      },
      price: "250",
      options: ""
    },
    {
      category: "non-alcoholic-specialties",
      translations: {
        en: {
          title: "Chaga Colada",
          description: "Better than a Coke in every way. Chaga mushroom extract, vanilla simple and soda water."
        },
        es: {
          title: "Chaga Colada",
          description: "Mejor que una Coca-Cola en todos los sentidos. Extracto de hongo Chaga, simple de vainilla y agua con gas."
        },
        fr: {
          title: "Chaga Colada",
          description: "Meilleur qu'un Coca à tous les égards. Extrait de champignon Chaga, sirop de vanille et eau gazeuse."
        },
        de: {
          title: "Chaga Colada",
          description: "Besser als eine Cola in jeder Hinsicht. Chaga-Pilzextrakt, Vanille-Sirup und Sodawasser."
        },
        "pt-BR": {
          title: "Chaga Colada",
          description: "Melhor que uma Coca-Cola em todos os aspectos. Extrato de cogumelo Chaga, xarope de baunilha e água com gás."
        },
        "es-MX": {
          title: "Chaga Colada",
          description: "Mejor que una Coca-Cola en todos los sentidos. Extracto de hongo Chaga, simple de vainilla y agua con gas."
        }
      },
      price: "80",
      options: ""
    },
    {
      category: "non-alcoholic-specialties",
      translations: {
        en: {
          title: "Kombucha",
          description: "Healthy probiotic soda. Ask about our seasonal flavors."
        },
        es: {
          title: "Kombucha",
          description: "Refresco probiótico saludable. Pregunta por nuestros sabores de temporada."
        },
        fr: {
          title: "Kombucha",
          description: "Soda probiotique sain. Demandez nos saveurs saisonnières."
        },
        de: {
          title: "Kombucha",
          description: "Gesundes probiotisches Erfrischungsgetränk. Fragen Sie nach unseren saisonalen Geschmacksrichtungen."
        },
        "pt-BR": {
          title: "Kombucha",
          description: "Refrigerante probiótico saudável. Pergunte sobre nossos sabores sazonais."
        },
        "es-MX": {
          title: "Kombucha",
          description: "Refresco probiótico saludable. Pregunta por nuestros sabores de temporada."
        }
      },
      price: "90",
      options: ""
    },
    {
      category: "non-alcoholic-specialties",
      translations: {
        en: {
          title: "Lemonade",
          description: "Pineapple, Blue Guava, Orange."
        },
        es: {
          title: "Limonada",
          description: "Piña, Guayaba Azul, Naranja."
        },
        fr: {
          title: "Citronnade",
          description: "Ananas, Goyave Bleue, Orange."
        },
        de: {
          title: "Limonade",
          description: "Ananas, Blaue Guave, Orange."
        },
        "pt-BR": {
          title: "Limonada",
          description: "Abacaxi, Goiaba Azul, Laranja."
        },
        "es-MX": {
          title: "Limonada",
          description: "Piña, Guayaba Azul, Naranja."
        }
      },
      price: "60",
      options: ""
    },
    {
      category: "non-alcoholic-specialties",
      translations: {
        en: {
          title: "Alfalfa Agua Fresca",
          description: "Alfalfa juice grown on the Finca with lime and raw sugar."
        },
        es: {
          title: "Agua Fresca de Alfalfa",
          description: "Jugo de alfalfa cultivado en la Finca con lima y azúcar cruda."
        },
        fr: {
          title: "Eau Fraîche d'Alfalfa",
          description: "Jus d'alfalfa cultivé sur la Finca avec citron vert et sucre brut."
        },
        de: {
          title: "Alfalfa Agua Fresca",
          description: "Alfalfa-Saft, angebaut auf der Finca, mit Limette und Rohzucker."
        },
        "pt-BR": {
          title: "Água Fresca de Alfafa",
          description: "Suco de alfafa cultivado na Finca com limão e açúcar mascavo."
        },
        "es-MX": {
          title: "Agua Fresca de Alfalfa",
          description: "Jugo de alfalfa cultivado en la Finca con limón y azúcar cruda."
        }
      },
      price: "60",
      options: ""
    }
  ]

  menu_items.each do |item|
    product = restaurant.products.create!(
      category: item[:category],
      price: item[:price],
      options: item[:options],
      active: true
    )

    item[:translations].each do |locale, translations|
      Mobility.with_locale(locale) do
        product.title = translations[:title]
        product.description = translations[:description]
        product.save!
      end
    end
  end

  %w[menu specialty-cocktails non-alcoholic-specialties].each_with_index do |category, index|
    range = (index + 1..index + 5)
    range.each do |i|
      Todo.create!(category: category, name: "Todo Item #{i} - #{category}", active: true, position: i)
    end
  end

  Flipper.enable_group(:super_admin_access, :admin_user)
  Flipper.enable(:super_admin_access)

  %w[
    sign_in
    sign_up
    enable_about
    enable_weekly_deals
    enable_subscribe
    enable_meet_the_team
    enable_gallery
    enable_testimonials
    enable_admin_locale
    enable_admin_dev_tools
  ].each do |feature|
    Flipper.disable(feature)
  end

  Schedule.create!(scheduleable_id: AdminUser.first.id, scheduleable_type: "AdminUser", name: "Appointment Availability", active: true, capacity: 3, exclude_lunch_time: false, beginning_of_week: "monday", time_zone: "Mountain Time (US & Canada)")

  Schedule.first.rules.create!(name: "Open Time Rule MWF", rule_type: "inclusion", frequency_units: "IceCube::MinutelyRule", frequency: 15, days_of_week: [ "monday", "wednesday", "friday" ], start_date: Date.today, end_date: Date.today + 90.days, rule_hour_start: "08:00", rule_hour_end: "12:00")
  Schedule.first.rules.create!(name: "Open Time Rule TTH", rule_type: "inclusion", frequency_units: "IceCube::MinutelyRule", frequency: 15, days_of_week: [ "tuesday", "thursday" ], start_date: Date.today, end_date: Date.today + 90.days, rule_hour_start: "17:15", rule_hour_end: "20:45")

end
