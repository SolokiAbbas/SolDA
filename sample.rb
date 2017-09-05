require_relative "lib/associatable"
require_relative "lib/sol_data_association"

class Parent < SolDataAssociation
  self.table_name = "parents"
  has_many :children, foreign_key: :parent_id
  has_many_through :toys, :children, :toys

  self.finalize!
end

class Child < SolDataAssociation
  self.table_name = "children"

  belongs_to :parents
  has_many :toys, foreign_key: :child_id

  self.finalize!
end

class Toy < SolDataAssociation
  self.table_name = "toys"

  belongs_to :children,
    class_name: "Child",
    foreign_key: :child_id,
    primary_key: :id

    self.finalize!
end
