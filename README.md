# SolDataAssociation
=======================================================================

SolDataAssociation uses Object-Relational mapping to associate models with each other. It uses sqlite3 to execute, open, and save to the database. It is inspired by ActiveRecord.

### Setup
=======================================================================
*Initial Setup*

Make the sql file, for example:

```
CREATE TABLE parents (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);
```

After the filling the database with values make the actual database:

```
cat parent.sql | sqlite3 parent.db
```

If adding a new database, edit the `lib/db_connection.rb` file lines 6, 7, 20, 21, and 25 to reflect the name of the new database name.

```
PARENT_SQL_FILE = File.join(ROOT_FOLDER, 'parent.sql')
PARENT_DB_FILE = File.join(ROOT_FOLDER, 'parent.db')
```

```
def self.reset
  commands = [
    "rm '#{PARENT_DB_FILE}'",
    "parent '#{PARENT_SQL_FILE}' | sqlite3 '#{PARENT_DB_FILE}'"
  ]

  commands.each { |command| `#{command}` }
  DBConnection.open(PARENT_DB_FILE)
end
```

### Gemfile
=======================================================================

Be sure to install required gems like 'sqlite3'.


### Associating the models
=======================================================================

Make your models and association in a file on your root directory. Be sure to include the following:

```
require_relative "lib/associatable"
require_relative "lib/sol_data_association"
```

The following associations executable:

* belongs_to
* has_many
* has_many_through
* has_one_through

`belongs_to` and `has_many` have the following options:

* relation_name
* :foreign_key
* :class_name
* :primary_key

`has_many_through` and `has_one_through` have the following options:

* name
* through
* source_name


There is a sample file called `sample.rb` in root directory. In order to run it, open pry in the terminal and `load 'sample.rb'`.

### Querying the Sample
=======================================================================

Database actions for the sample and other databases include the following:

* insert
* update
* save
* find
* finalize! (to save into the database)

For Example:

```
Parent.find(1)
Parent.find(1).children
```

In order to update or insert, create and new `Parent` object and either insert or update the table:

```
parent1 = Parent.new
parent1.id = 3
parent1.name = "John and Carrie"
parent1.insert
```
