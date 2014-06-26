require 'find_as_hashes'
require 'test/unit'
require 'turn'
require 'shoulda'
require 'active_record/fixtures'
require 'sqlite3'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :name
    t.date :birthday
    t.boolean :active
    t.integer :role_id
  end
end

ActiveRecord::Schema.define do
  create_table :roles, :force => true do |t|
    t.string :name
    t.boolean :admin
  end
end

class User < ActiveRecord::Base
  belongs_to :role
end

class Role < ActiveRecord::Base
  has_many :user
end

# Rails 3 has Fixtures, Rails 4 has ActiveRecord::FixtureSet
fixtures_class = defined?(ActiveRecord::FixtureSet) ? ActiveRecord::FixtureSet : ActiveRecord::Fixtures
fixtures_class.create_fixtures "test/fixtures", :roles
fixtures_class.create_fixtures "test/fixtures", :users
