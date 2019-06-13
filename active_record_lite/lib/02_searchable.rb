require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  
  
  def where(params)
    search_params = params.keys.map { |key| "#{key.to_s} = '#{params[key]}'" }.join(' AND ')
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
        FROM 
        #{self.table_name}
        WHERE
        #{search_params}
    SQL
    self.parse_all(data)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
