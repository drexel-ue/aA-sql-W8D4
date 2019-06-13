require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns.nil?
      data = DBConnection.execute2(<<-SQL)
        select * from #{table_name} limit 1
      SQL

      @columns = []
      data.first.each do |col|
        @columns << col.to_sym
      end
      @columns
    else
      @columns
    end
  
  end

  def self.finalize!
    SQLObject.columns.each do |column|
      define_method("#{column}=") do |ref|
        self.attributes[column] = ref
      end
      define_method(column) do
        self.attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= 'cats'
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      SQL
      self.parse_all(data)
  end

  def self.parse_all(results)
    objs = []
    results.each do |result|
      objs << self.new(result)
    end
    objs
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |key, val|
      if !self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end
      self.send("#{key}=", val)
    end
    
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
  self.finalize!

end
