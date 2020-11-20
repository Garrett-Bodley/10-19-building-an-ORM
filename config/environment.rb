require 'bundler'
Bundler.require

# DB = SQLite3::Database.new('db/twitter.db')    
# DB.execute

DB = {conn: SQLite3::Database.new('db/twitter.db')}
# DB[:conn].execute

DB[:conn].results_as_hash = true 

require_relative '../lib/tweet'
require_relative '../db/seed'
require_relative '../lib/author'

Tweet.create_table
Author.create_table