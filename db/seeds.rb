# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 创建 AdminUser (仅在开发环境下)
# 使用 find_or_create_by! 来避免重复创建记录
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
  puts "AdminUser created"
end if Rails.env.development?

# 创建普通的管理员用户
# 使用不同的电子邮件地址，避免与 AdminUser 冲突
User.find_or_create_by!(email: 'user_admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.admin = true
  puts 'Admin user created'
end

# 创建静态页面
# In db/seeds.rb
['About', 'Contact'].each do |page_name|
    slug = page_name.downcase
    Page.find_or_create_by(slug: slug) do |page|
      page.title = page_name
      page.content = "This is the #{page_name} page content. Edit this in the admin dashboard."
      puts "Created #{page_name} page"
    end
  end

# Create categories
categories = [
  { name: 'Furniture', description: 'Gently used furniture items for your home' },
  { name: 'Electronics', description: 'Pre-owned electronics in good working condition' },
  { name: 'Clothing', description: 'Quality second-hand clothing and accessories' },
  { name: 'Books', description: 'Used books in good condition' }
]

categories.each do |category_data|
  Category.find_or_create_by(name: category_data[:name]) do |category|
    category.description = category_data[:description]
    puts "Created category: #{category.name}"
  end
end

# Get created categories
all_categories = Category.all

# Create products with Faker
conditions = ['Like New', 'Good', 'Fair', 'Poor']

if Product.count < 100
  100.times do |i|
    product = Product.create!(
      title: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      price: Faker::Commerce.price(range: 5.0..500.0),
      condition: conditions.sample,
      quantity: Faker::Number.between(from: 1, to: 10),
      sku: "SKU-#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
      is_featured: [true, false].sample
    )
    
    # Associate with 1-3 random categories
    product.categories << all_categories.sample(rand(1..3))
    puts "Created product ##{i+1}: #{product.title}"
  end
end