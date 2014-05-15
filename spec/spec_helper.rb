require 'bundler/setup'
Bundler.setup

require 'active_record'
require 'sqlite3'
require 'validity'

I18n.enforce_available_locales = false

RSpec.configure do |config|
end

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3',
  pool: 5,
  timeout: 5000
)

class Migrations < ActiveRecord::Migration
  def users
    drop_table :users rescue nil
    create_table :users do |t|
      t.string :email, null: false, unique: true
    end
  end

  def posts
    drop_table :posts rescue nil
    create_table :posts do |t|
      t.string :body, null: false
      t.references :user, null: false
    end
  end
end
migrations = Migrations.new
migrations.users
migrations.posts

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :posts
end

class Post < ActiveRecord::Base
  validates :body, presence: true
  validates :user_id, presence: true

  belongs_to :user

  delegate :email, to: :user
end

