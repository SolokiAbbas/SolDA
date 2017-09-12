require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
# Be sure to edit filenames here
PARENT_SQL_FILE = File.join(ROOT_FOLDER, 'parent.sql')
PARENT_DB_FILE = File.join(ROOT_FOLDER, 'parent.db')

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    # File names here need to be changed too
    commands = [
      "rm '#{PARENT_DB_FILE}'",
      "parent '#{PARENT_SQL_FILE}' | sqlite3 '#{PARENT_DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    #Finally edit the filename here
    DBConnection.open(PARENT_DB_FILE)
  end

  def self.instance
    reset if @db.nil?
    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end
  # execute 2 returns always the names of the columns
  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
