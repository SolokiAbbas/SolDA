require_relative 'db_connection'
require_relative 'sol_data_association'

module Searchable
  def where(params)
    # receives a param which then joins its many attributes for a query
    where_line = params.keys.map{ |k| "#{k} = ? " }.join("AND ")
    vals = params.values
    location = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    location.map{ |h| self.new(h) }

  end
end

class SolDataAssociation
  extend Searchable
end
