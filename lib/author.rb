class Author

  attr_accessor :name, :id

  def initialize(attr_hash={})
      #is NOT responsible for sending attributes to the db
      # is resonsible for assign the attributes that we get FROM the db to objects
      attr_hash.each do |key, value|
          if self.respond_to?("#{key.to_s}=")
              self.send("#{key.to_s}=", value)
          end
          #self.content=(value)
      end
      #{content: Faker::Quote.matz, author: 'Matz'}
  end

  def self.all
      array_of_hashes = DB[:conn].execute("SELECT * FROM authors")
      array_of_hashes.collect do |hash|
        self.new(hash)
      end
  end

  def self.find(id)
      sql = "SELECT * from authors WHERE authors.id = ?"
      obj_hash = DB[:conn].execute(sql, id)[0]
      self.new(obj_hash)
  end


  def save 
    if !!self.id  
      sql = <<-SQL 
        UPDATE authors
        SET name = ?
        WHERE id = ?;
      SQL
      DB[:conn].execute(sql, self.name, self.id)
    else
        # if it is not already saved, add to db
        sql = <<-SQL 
            INSERT INTO authors (name) 
            VALUES (?)
        SQL
        DB[:conn].execute(sql, self.name)
        @id = DB[:conn].last_insert_row_id
    end
    self
  end

  def self.create_table 
    # responsible for creating a class
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS authors (
          id INTEGER PRIMARY KEY,
          name TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  #has_many :tweets

  def tweets
    sql = "SELECT * from tweets WHERE tweets.author_id = ?"
    DB[:conn].execute(sql, self.id).map do |tweet|
      Tweet.new(tweet)
    end

    #Tweet.all.select do |tweet|
    #  tweet.author_id == self.id
    #end
  end

  def tweet_ids
    self.tweets.map do |tweet|
      tweet.id
    end
  end
  def tweet_ids=(array)
    array.each do |id|
      t = Tweet.find(id)
      t.author_id = self.id
      t.save
    end
  end

  def self.create(hash)
    self.new(hash).save
  end
end