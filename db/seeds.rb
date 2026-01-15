puts "Cleaning database..."
Wine.destroy_all
Storage.destroy_all
User.destroy_all

puts "Creating users..."

user = User.create!(
  email: "demo@cavin.fr",
  password: "password123",
  password_confirmation: "password123"
)

puts "Created user: #{user.email}"

puts "Creating storages..."

storage1 = Storage.create!(
  user: user,
  name: "Cantina di Casa",
  category: "Cave",
  rows: 6,
  cols: 8,
  photo_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800"
)

storage2 = Storage.create!(
  user: user,
  name: "Vinoteca Soggiorno",
  category: "Vinothèque salon",
  rows: 4,
  cols: 6,
  photo_url: "https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=800"
)

storage3 = Storage.create!(
  user: user,
  name: "Armadietto Cucina",
  category: "Meuble cuisine",
  rows: 3,
  cols: 5,
  photo_url: "https://images.unsplash.com/photo-1578911373434-0cb395d2cbfb?w=800"
)

storage4 = Storage.create!(
  user: user,
  name: "Armadietto Cuclina",
  category: "Vinothèque cuisine",
  rows: 3,
  cols: 5,
  photo_url: "https://images.unsplash.com/photo-1568213816046-0ee1c42bd559?w=800"
)

puts "Created #{Storage.count} storages"

puts "Creating wines..."

wines_data_1 = [
  { name: "Château Margaux 2015", wine_type: "Rouge", region: "Bordeaux", price: 450.00, row_position: 1, col_position: 1 },
  { name: "Pétrus 2010", wine_type: "Rouge", region: "Pomerol", price: 2500.00, row_position: 1, col_position: 2 },
  { name: "Domaine de la Romanée-Conti", wine_type: "Rouge", region: "Bourgogne", price: 5000.00, row_position: 1, col_position: 3 },
  { name: "Sassicaia 2016", wine_type: "Rouge", region: "Toscane", price: 180.00, row_position: 2, col_position: 1 },
  { name: "Opus One 2018", wine_type: "Rouge", region: "Napa Valley", price: 320.00, row_position: 2, col_position: 2 },
  { name: "Tignanello 2017", wine_type: "Rouge", region: "Toscane", price: 95.00, row_position: 2, col_position: 3 },
  { name: "Barolo Riserva 2013", wine_type: "Rouge", region: "Piémont", price: 120.00, row_position: 3, col_position: 1 },
  { name: "Amarone della Valpolicella", wine_type: "Rouge", region: "Vénétie", price: 85.00, row_position: 3, col_position: 2 },
  { name: "Châteauneuf-du-Pape 2019", wine_type: "Rouge", region: "Rhône", price: 75.00, row_position: 3, col_position: 3 },
  { name: "Brunello di Montalcino 2016", wine_type: "Rouge", region: "Toscane", price: 110.00, row_position: 4, col_position: 1 },
]

wines_data_1.each do |wine_data|
  Wine.create!(wine_data.merge(storage: storage1))
end

wines_data_2 = [
  { name: "Dom Pérignon 2012", wine_type: "Champagne", region: "Champagne", price: 180.00, row_position: 1, col_position: 1 },
  { name: "Krug Grande Cuvée", wine_type: "Champagne", region: "Champagne", price: 200.00, row_position: 1, col_position: 2 },
  { name: "Cristal Roederer 2013", wine_type: "Champagne", region: "Champagne", price: 250.00, row_position: 1, col_position: 3 },
  { name: "Chablis Grand Cru 2020", wine_type: "Blanc", region: "Bourgogne", price: 90.00, row_position: 2, col_position: 1 },
  { name: "Puligny-Montrachet 2019", wine_type: "Blanc", region: "Bourgogne", price: 120.00, row_position: 2, col_position: 2 },
  { name: "Sancerre 2021", wine_type: "Blanc", region: "Loire", price: 35.00, row_position: 2, col_position: 3 },
]

wines_data_2.each do |wine_data|
  Wine.create!(wine_data.merge(storage: storage2))
end

wines_data_3 = [
  { name: "Côtes du Rhône 2020", wine_type: "Rouge", region: "Rhône", price: 15.00, row_position: 1, col_position: 1 },
  { name: "Chianti Classico 2021", wine_type: "Rouge", region: "Toscane", price: 18.00, row_position: 1, col_position: 2 },
  { name: "Pinot Grigio 2022", wine_type: "Blanc", region: "Vénétie", price: 12.00, row_position: 1, col_position: 3 },
  { name: "Vermentino 2022", wine_type: "Blanc", region: "Sardaigne", price: 14.00, row_position: 2, col_position: 1 },
  { name: "Rosé de Provence 2022", wine_type: "Rosé", region: "Provence", price: 16.00, row_position: 2, col_position: 2 },
]

wines_data_3.each do |wine_data|
  Wine.create!(wine_data.merge(storage: storage3))
end

wines_data_4 = [
  { name: "Montepulciano d'Abruzzo", wine_type: "Rouge", region: "Abruzzes", price: 13.00, row_position: 1, col_position: 1 },
  { name: "Valpolicella Ripasso", wine_type: "Rouge", region: "Vénétie", price: 22.00, row_position: 1, col_position: 2 },
  { name: "Soave Classico", wine_type: "Blanc", region: "Vénétie", price: 11.00, row_position: 1, col_position: 3 },
]

wines_data_4.each do |wine_data|
  Wine.create!(wine_data.merge(storage: storage4))
end

puts "Created #{Wine.count} wines"

consumed_wines = [
  { name: "Château Lafite Rothschild 2005", wine_type: "Rouge", region: "Bordeaux", price: 800.00, storage: storage1, consumed_at: 2.months.ago },
  { name: "Moët & Chandon Impérial", wine_type: "Champagne", region: "Champagne", price: 45.00, storage: storage2, consumed_at: 1.week.ago },
  { name: "Barbera d'Alba 2020", wine_type: "Rouge", region: "Piémont", price: 16.00, storage: storage3, consumed_at: 3.days.ago },
]

consumed_wines.each do |wine_data|
  Wine.create!(wine_data)
end

puts "Created #{Wine.where.not(consumed_at: nil).count} consumed wines"

puts "
✅ Seed completed successfully!

👤 Demo User:
   Email: demo@cavin.fr
   Password: password123

📊 Stats:
   - #{User.count} user(s)
   - #{Storage.count} storage(s)
   - #{Wine.where(consumed_at: nil).count} active wine(s)
   - #{Wine.where.not(consumed_at: nil).count} consumed wine(s)
"
