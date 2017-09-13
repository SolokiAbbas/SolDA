require_relative 'db_connection'
require 'active_support/inflector'

class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |var|
      define_method("#{var}=") do |value|
        self.instance_variable_set("@#{var}", value)
      end

      define_method(var) do
        self.instance_variable_get("@#{var}")
      end
    end
  end
end

class SolDataAssociation
  def self.columns
    # get column names only
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    @columns.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |att|

        define_method("#{att}=") do |value = self.attributes[att]|
          self.attributes[att] = value
        end

        define_method(att) do
          self.attributes[att]
        end
    end

  end

  def self.table_name=(table_name)
    name = table_name.downcase
    @table_name = "#{name}"
  end

  def self.table_name
    @table_name ||= "#{self.name.downcase}s"
  end

  def self.all
    all_data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    all_data.map{|res| self.new(res)}
  end

  def self.parse_all(results)
    #creating a new instance of each
    results.map{ |res| self.new(res) }
  end

  def self.find(id)
    finder = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    if finder.first.nil?
      return nil
    else
      self.new(finder.first)
    end

  end

  def initialize(params = {})
    params.each do |key, value|
      k = key.to_sym
      if self.class.columns.include?(k)
        self.send("#{k}=", value)
      else
        raise "unknown attribute '#{k}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # sets the attribute value of the table
    array_values = []
    col_names = self.class.columns
    col_names.map{|col| array_values << self.send("#{col}")}.first
  end

  def insert
    col_length = self.class.columns.length
    col_names = self.class.columns.join(",")
    question_marks = (["?"] * col_length).join(",")
    # figures out the length of ? to set dynamic number of ?
    att = attribute_values
    inserting = DBConnection.execute(<<-SQL, *att)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
       (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_set = self.class.columns.map{|ids| "#{ids} = ?"}.join(",")
    att = attribute_values
    inserting = DBConnection.execute(<<-SQL, *att)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_set}
      WHERE
        id = #{self.id}
    SQL
  end

  def delete_current
    current = self.id
    inserting = DBConnection.execute(<<-SQL, current)
      DELETE FROM
        #{self.class.table_name}
      WHERE
       id = #{self.id}
    SQL
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end
end
