source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'bcrypt-ruby', '~> 3.0.0'
gem "bootstrap-sass", "2.3.1.0"
gem 'devise', "3.1.1"
gem 'cancan', "1.6.10"
gem 'awesome_print'
gem 'mailboxer', "0.11.0", git: 'git://github.com/ging/mailboxer.git'
gem 'nokogiri'
gem 'curb'
gem 'omniauth-stripe-connect'
gem 'stripe'
gem 'carrierwave', "0.9.0"
gem 'fog'
gem 'rmagick'
gem 'tinymce-rails', '4.0.2', :path => "vendor/gems/tinymce-rails-4.0.2"
gem 'roo' 
# Gems used only for assets and not required
# in production environments by default.
group :development do
  gem 'foreman'
	gem 'quiet_assets'
	gem 'thin'
	gem 'debugger'
	gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'thin'
  gem 'memcachier'
  gem 'dalli'
end


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # gem 'jquery-fileupload-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# gem 'omniauth-twitter'
gem 'omniauth-facebook'