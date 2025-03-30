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
  ActiveRecord::Base.transaction do
    all_categories.each do |category|
      25.times do |i|
        begin
          product_name = case category.name
          when 'Furniture'
            ["Sofa", "Dining Table", "Bed", "Wardrobe", "Desk"].sample
          when 'Electronics'
            ["Smartphone", "Laptop", "Tablet", "Smart Watch", "Headphones"].sample
          when 'Clothing'
            color = ["Black", "White", "Blue", "Red", "Gray"].sample
            item = ["T-shirt", "Jeans", "Dress", "Jacket", "Shirt"].sample
            "#{color} #{item}"
          when 'Books'
            ["The Great Gatsby", "To Kill a Mockingbird", "1984", "Pride and Prejudice", "The Catcher in the Rye"].sample
          else
            Faker::Commerce.product_name
          end

          product = Product.create!(
            title: product_name,
            description: Faker::Lorem.paragraph(sentence_count: 5),
            price: Faker::Commerce.price(range: 5.0..500.0),
            condition: conditions.sample,
            quantity: Faker::Number.between(from: 1, to: 10),
            sku: "SKU-#{category.name[0..2].upcase}-#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
            is_featured: [true, false].sample
          )

          product.categories << category
          puts "Created #{category.name} product ##{i+1}: #{product.title}"
        rescue => e
          puts "Error creating product for #{category.name}: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end

# Add Canadian provinces
provinces_data = [
  { name: 'Alberta', code: 'AB', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'British Columbia', code: 'BC', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'Manitoba', code: 'MB', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'New Brunswick', code: 'NB', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Northwest Territories', code: 'NT', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Nova Scotia', code: 'NS', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Nunavut', code: 'NU', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Ontario', code: 'ON', gst: 0.0, pst: 0.0, hst: 13.0 },
  { name: 'Prince Edward Island', code: 'PE', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Quebec', code: 'QC', gst: 5.0, pst: 9.975, hst: 0.0 },
  { name: 'Saskatchewan', code: 'SK', gst: 5.0, pst: 6.0, hst: 0.0 },
  { name: 'Yukon', code: 'YT', gst: 5.0, pst: 0.0, hst: 0.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(code: province_data[:code]) do |province|
    province.assign_attributes(province_data)
    puts "Created province: #{province.name}"
  end
end