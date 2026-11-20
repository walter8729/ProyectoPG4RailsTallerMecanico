# db/seeds.rb
# Carga inicial y datos demo del Sistema de Taller Mecánico

puts "Limpiando datos existentes..."
Assignment.destroy_all
OrderDetail.destroy_all
Order.destroy_all
Car.destroy_all
Customer.destroy_all
Mechanic.destroy_all
Service.destroy_all

puts "Creando Mecánicos..."
mechanics_data = [
  { first_name: "Carlos", last_name: "González", specialty: "Mecánica General", phone: "0981 123 456" },
  { first_name: "Marcos", last_name: "Benítez", specialty: "Electricidad Automotriz", phone: "0982 234 567" },
  { first_name: "Luis", last_name: "Ramírez", specialty: "Inyección y Diagnóstico OBD", phone: "0983 345 678" },
  { first_name: "Hugo", last_name: "Martínez", specialty: "Frenos y Suspensión", phone: "0984 456 789" },
  { first_name: "Jorge", last_name: "Villalba", specialty: "Aire Acondicionado y Climatización", phone: "0985 567 890" }
]
created_mechanics = mechanics_data.map { |m| Mechanic.create!(m) }

puts "Creando Catálogo de Servicios..."
services_data = [
  { name: "Cambio de aceite y filtro de motor", price: 350000, description: "4 litros de aceite (semi o sintético), filtro y mano de obra." },
  { name: "Reemplazo de filtros (aire, cabina y combustible)", price: 210000, description: "Repuestos alternativos u originales + colocación." },
  { name: "Control y reposición de fluidos", price: 70000, description: "Relleno de refrigerante, líquido de frenos y limpiaparabrisas." },
  { name: "Cambio de bujías y cables de encendido", price: 280000, description: "Juego de 4 bujías estándar (iridio cuesta más) + mano de obra." },
  { name: "Alineación y balanceo", price: 140000, description: "Alineación 3D delantera/trasera + balanceo de las 4 ruedas." },
  { name: "Rotación de cubiertas", price: 60000, description: "Desmontaje, cruce de neumáticos y calibración de presión." },
  { name: "Cambio de amortiguadores y espirales", price: 220000, description: "Solo mano de obra por eje (repuestos cuestan desde 350.000 c/u)." },
  { name: "Reparación de tren delantero", price: 350000, description: "Mano de obra por cambio de bujes, rótulas o extremos." },
  { name: "Cambio de pastillas de freno", price: 260000, description: "Juego de pastillas delanteras + instalación." },
  { name: "Rectificación o cambio de discos/campanas", price: 180000, description: "Torneado/rectificación del par (discos nuevos aparte)." },
  { name: "Purga y cambio de líquido de frenos", price: 110000, description: "1 litro de líquido DOT 3/DOT 4 + purgado completo." },
  { name: "Cambio de kit de distribución", price: 550000, description: "Mano de obra (kit de correa, tensor y bomba aparte)." },
  { name: "Cambio de correa poli-V (accesorios)", price: 180000, description: "Correa nueva + mano de obra de instalación." },
  { name: "Servicio de transmisión / caja automática", price: 700000, description: "Aceite ATF especial, filtro/junta (si aplica) y mano de obra." },
  { name: "Reemplazo de kit de embrague", price: 500000, description: "Solo mano de obra (kit de disco, placa y rulemán aparte)." },
  { name: "Diagnóstico computarizado (escaneo OBD)", price: 120000, description: "Lectura y borrado de códigos de falla con escáner." },
  { name: "Control y cambio de batería", price: 550000, description: "Batería nueva (45 a 65 Ah) entregando la usada + test de carga." },
  { name: "Limpieza de inyectores y cuerpo de aceleración", price: 210000, description: "Limpieza por ultrasonido, cambio de microfiltros y calibración." },
  { name: "Mantenimiento de aire acondicionado", price: 220000, description: "Vacío, prueba de fugas, aceite de compresor y carga de gas R134a." },
  { name: "Limpieza del sistema de refrigeración", price: 210000, description: "Drenaje, lavado interno del radiador y carga de refrigerante nuevo." }
]
created_services = services_data.map { |s| Service.create!(s) }

puts "Creando 38 Clientes..."
customers_raw = [
  { doc: "7.030.890", last: "Ramos Paiva", first: "José David" },
  { doc: "6.160.044", last: "Britez Vázquez", first: "Isabel" },
  { doc: "5.853.084", last: "Dionich Lugo", first: "Guillermo Sebastián" },
  { doc: "7.936.462", last: "Lopez Goroñoski", first: "Ayelen Monserrat" },
  { doc: "6.765.861", last: "Paredes Valdez", first: "Abigail Elisabet" },
  { doc: "7.274.614", last: "Barbarín González", first: "Siara Belén" },
  { doc: "6.587.671", last: "Agüero Bobadilla", first: "Luis Alberto" },
  { doc: "7.523.097", last: "Delvalle Cuella", first: "Liz Maria" },
  { doc: "5.741.569", last: "Ramoa Altamirano", first: "Amira" },
  { doc: "5.674.386", last: "Duarte Duarte", first: "Judith Dahiana" },
  { doc: "8.508.693", last: "Ferreira Villar", first: "Leandro Sanmuel" },
  { doc: "5.328.368", last: "Carrera Ortega", first: "Damaris Karina" },
  { doc: "6.049.941", last: "Ruiz Diaz Segovia", first: "Sebastian Emanuel" },
  { doc: "5.829.304", last: "López Escobar", first: "Hugo Javier" },
  { doc: "6.347.218", last: "Cuevas Okamura", first: "Dahiana Yulisa" },
  { doc: "6.189.438", last: "Cáceres Espínola", first: "Ever Alcides" },
  { doc: "6.188.889", last: "Urbina Benitez", first: "Axel Gabriel" },
  { doc: "4.691.316", last: "López Segovia", first: "Adolfo Ruben" },
  { doc: "5.743.853", last: "Cáceres Montania", first: "Luis Mario" },
  { doc: "6.071.114", last: "Franco Molinas", first: "Matías Nicolás" },
  { doc: "5.533.136", last: "Britez Gimenez", first: "Jessica Mariel" },
  { doc: "5.735.159", last: "Cáceres Montania", first: "Fernando David" },
  { doc: "8.098.610", last: "Quiñonez Sanabria", first: "Nahuel David" },
  { doc: "5.732.273", last: "Godoy Acosta", first: "Rubén Dario" },
  { doc: "7.905.551", last: "Garay Avalos", first: "Mathias Waldemar" },
  { doc: "5.613.487", last: "Martínez López", first: "Erika Magalí" },
  { doc: "6.126.721", last: "Gaona Franco", first: "Luz Monserrat" },
  { doc: "6.786.064", last: "Posdeley Báez", first: "Moises Gabriel" },
  { doc: "5.879.535", last: "Bogado Ortiz", first: "Aixa Maylen" },
  { doc: "6.811.384", last: "Acevedo Aguilera", first: "Esteban David" },
  { doc: "5.667.941", last: "Cáceres Espinola", first: "Junior Isaac" },
  { doc: "6.605.401", last: "Venialgo Benítez", first: "Lorena Soledad" },
  { doc: "5.411.585", last: "Recalde Gamarra", first: "Kevin Marcelo" },
  { doc: "5.786.773", last: "García Acosta", first: "Felipe Daniel" },
  { doc: "5.714.617", last: "Benitez Gonzalez", first: "Jorge Ezequiel" },
  { doc: "7.880.251", last: "Ovelar Figueredo", first: "Alexis Daniel" },
  { doc: "6.588.634", last: "Araujo Chamorro", first: "Luis Fernando" },
  { doc: "5.645.294", last: "Cardozo Cantero", first: "Fernando Julián" }
]

created_customers = customers_raw.each_with_index.map do |c, i|
  clean_doc = c[:doc].delete(".")
  slug_name = c[:first].parameterize(separator: ".")
  slug_last = c[:last].parameterize(separator: ".")
  email = "#{slug_name}.#{slug_last}@gmail.com"
  phone = "0981 #{rand(100..999)} #{rand(100..999)}"
  address = "Asunción, Calle #{i + 1} e/ #{c[:last]}"

  Customer.create!(
    document_type: "CI",
    document_number: clean_doc,
    first_name: c[:first],
    last_name: c[:last],
    phone: phone,
    email: email,
    address: address
  )
end

puts "Creando Vehículos asociados a Clientes..."
cars_catalog = [
  { brand: "Toyota", model: "Hilux", years: (2015..2024).to_a, colors: ["Blanco", "Plata", "Gris Oscuro", "Negro"] },
  { brand: "Toyota", model: "Vitz", years: (2005..2018).to_a, colors: ["Plata", "Blanco", "Rojo", "Azul", "Negro"] },
  { brand: "Toyota", model: "Allion", years: (2004..2016).to_a, colors: ["Blanco Perla", "Plata", "Negro", "Champagne"] },
  { brand: "Toyota", model: "Premio", years: (2004..2016).to_a, colors: ["Blanco Perla", "Plata", "Negro", "Bordó"] },
  { brand: "Toyota", model: "Corolla", years: (2010..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro"] },
  { brand: "Toyota", model: "Corolla Cross", years: (2021..2024).to_a, colors: ["Blanco Perla", "Gris", "Plata", "Azul"] },
  { brand: "Toyota", model: "Fortuner", years: (2012..2024).to_a, colors: ["Blanco", "Negro", "Plata", "Gris"] },
  { brand: "Toyota", model: "RAV4", years: (2010..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Azul"] },
  { brand: "Kia", model: "Picanto", years: (2012..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Rojo", "Negro"] },
  { brand: "Kia", model: "Soluto", years: (2019..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Azul"] },
  { brand: "Kia", model: "Rio", years: (2012..2023).to_a, colors: ["Blanco", "Plata", "Gris", "Rojo", "Negro"] },
  { brand: "Kia", model: "Sportage", years: (2011..2024).to_a, colors: ["Blanco", "Gris", "Plata", "Negro"] },
  { brand: "Kia", model: "Seltos", years: (2020..2024).to_a, colors: ["Blanco", "Gris", "Negro", "Naranja"] },
  { brand: "Hyundai", model: "HB20", years: (2015..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Rojo", "Negro"] },
  { brand: "Hyundai", model: "Creta", years: (2017..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro"] },
  { brand: "Hyundai", model: "Tucson", years: (2011..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Azul"] },
  { brand: "Chevrolet", model: "S10", years: (2013..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro"] },
  { brand: "Chevrolet", model: "Onix", years: (2014..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Rojo"] },
  { brand: "Chevrolet", model: "Tracker", years: (2015..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Azul"] },
  { brand: "Nissan", model: "Frontier", years: (2012..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Rojo"] },
  { brand: "Nissan", model: "Kicks", years: (2017..2024).to_a, colors: ["Blanco", "Gris", "Plata", "Naranja", "Negro"] },
  { brand: "Volkswagen", model: "Amarok", years: (2011..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Azul"] },
  { brand: "Volkswagen", model: "Gol", years: (2008..2023).to_a, colors: ["Blanco", "Plata", "Gris", "Rojo", "Negro"] },
  { brand: "Volkswagen", model: "T-Cross", years: (2019..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Azul"] },
  { brand: "Fiat", model: "Strada", years: (2012..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Rojo"] },
  { brand: "Fiat", model: "Toro", years: (2016..2024).to_a, colors: ["Blanco", "Gris", "Bordó", "Negro"] },
  { brand: "Suzuki", model: "Swift", years: (2010..2024).to_a, colors: ["Blanco", "Plata", "Rojo", "Azul", "Gris"] },
  { brand: "Ford", model: "Ranger", years: (2012..2024).to_a, colors: ["Blanco", "Plata", "Gris", "Negro", "Azul"] }
]

created_cars = []
letters = ("A".."Z").to_a

created_customers.each_with_index do |customer, idx|
  # Cada cliente tendrá entre 1 y 2 autos
  num_cars = (idx % 4 == 0) ? 2 : 1

  num_cars.times do |c_idx|
    preset = cars_catalog[(idx * 2 + c_idx) % cars_catalog.size]
    plate = "#{letters[(idx * 3 + c_idx) % 26]}#{letters[(idx + 5) % 26]}#{letters[(idx + 9) % 26]} #{rand(100..999)}"
    chassis = "93H#{letters.sample}#{letters.sample}#{rand(10000000..99999999)}"
    year = preset[:years].sample
    color = preset[:colors].sample
    mileage = rand(15000..180000)

    car = Car.create!(
      customer: customer,
      brand: preset[:brand],
      model: preset[:model],
      year: year,
      color: color,
      plate: plate,
      chassis: chassis,
      mileage: mileage
    )
    created_cars << car
  end
end

puts "Creando Órdenes de Trabajo demo con Asignaciones y Servicios..."
statuses = ["Pendiente", "En Proceso", "Completada"]

# Creamos ~20 órdenes de trabajo repartidas entre los vehículos
created_cars.first(20).each_with_index do |car, idx|
  status = statuses[idx % 3]
  days_ago = rand(1..20)
  order_date = Date.current - days_ago.days
  delivery_date = (status == "Completada") ? order_date + rand(1..3).days : nil

  observations = [
    "Ruido metálico al frenar y vibración en el volante.",
    "Mantenimiento programado de kilometraje y cambio de fluidos.",
    "El aire acondicionado no enfría lo suficiente.",
    "Pérdida ligera de líquido refrigerante en frío.",
    "Luz de Check Engine encendida en tablero.",
    "Dificultad en arranque matutino y tirones al acelerar."
  ].sample

  order = Order.create!(
    car: car,
    order_date: order_date,
    delivery_date: delivery_date,
    status: status,
    notes: observations,
    total: 0
  )

  # Asignar 1 o 2 mecánicos
  assigned_mechanics = created_mechanics.sample(rand(1..2))
  assigned_mechanics.each do |mechanic|
    order.assignments.create!(mechanic: mechanic, assigned_at: order_date)
  end

  # Agregar 1 a 3 servicios a la orden
  selected_services = created_services.sample(rand(1..3))
  selected_services.each do |service|
    qty = (service.name.include?("aceite") || service.name.include?("bujías")) ? rand(1..2) : 1
    unit_price = service.price
    order.order_details.create!(
      service: service,
      quantity: qty,
      unit_price: unit_price,
      subtotal: qty * unit_price
    )
  end

  order.recalculate_total!
end

puts "=========================================================="
puts "Seed completado con éxito:"
puts " - #{Mechanic.count} Mecánicos creados."
puts " - #{Service.count} Servicios registrados con precios en PYG."
puts " - #{Customer.count} Clientes cargados con sus Cédulas reales."
puts " - #{Car.count} Vehículos generados con marcas, modelos y chapa."
puts " - #{Order.count} Órdenes de trabajo con mecánicos y servicios."
puts "=========================================================="
