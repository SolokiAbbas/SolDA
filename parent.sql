CREATE TABLE parents (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE children (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  parent_id INTEGER NOT NULL,

  FOREIGN KEY(parent_id) REFERENCES parents(id)
);

CREATE TABLE toys (
  id INTEGER PRIMARY KEY,
  type VARCHAR(255) NOT NULL,
  child_id INTEGER,

  FOREIGN KEY(child_id) REFERENCES children(id)
);

INSERT INTO
  parents (id, name)
VALUES
  (1, "Jane & John"), (2, "Jackie & Jimmy");

INSERT INTO
  children (id, fname, lname, parent_id)
VALUES
  (1, "Matt", "Watts", 1),
  (2, "Nancy", "Rubens", 1),
  (3, "Nathan", "Ram", 2);

INSERT INTO
  toys (id, type, child_id)
VALUES
  (1, "Doll", 1),
  (2, "Action Figure", 1),
  (3, "Clay", 2),
  (4, "Dough", 2);
