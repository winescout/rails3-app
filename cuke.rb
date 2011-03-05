gem "capybara", ">= 0.4.0", :group => [:cucumber, :test]
gem "cucumber-rails", ">= 0.3.2", :group => [:cucumber, :test]
gem "database_cleaner", ">= 0.5.2", :group => [:cucumber, :test]
gem "factory_girl_rails", ">= 1.0.0", :group => [:cucumber, :test]
gem "factory_girl_generator", ">= 0.0.1", :group => [:cucumber, :development, :test]
gem "haml-rails", ">= 0.3.4"
gem "launchy", ">= 0.3.7", :group => [:cucumber, :test]
gem "rspec-rails", ">= 2.2.1", :group => [:cucumber, :development, :test]
gem "spork", ">= 0.8.4", :group => [:cucumber, :test]
gem "devise"

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.integration_tool :rspec
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
`curl https://github.com/rails/jquery-ujs/raw/master/src/rails.js -o public/javascripts/rails.js`

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
  config/database.yml
db/*.sqlite3
END

run "rvm use --create --rvmrc ruby-1.9.2@#{app_name}"
run "gem install bundler"
run "bundle install"

generate 'rspec:install'
generate 'cucumber:install --rspec --capybara'
generate 'devise:install'
generate 'devise User'
route 'devise_for :users'

generate :controller, "welcome index"
route 'root :to => "welcome#index"'



git :init
git :add => "."

docs = <<-DOCS

Run the following commands to complete the setup of #{app_name.humanize}:

% cd #{app_name}
% rvm use --create --rvmrc ruby-1.9.2@#{app_name}
% gem install bundler
% bundle install
% script/rails generate rspec:install
% script/rails generate cucumber:install --rspec --capybara

DOCS

log docs
