-- System
CREATE TABLE meta (
  name TEXT UNIQUE,
  value TEXT
);

INSERT INTO meta VALUES ("db_schema", "1");

-- Account
CREATE TABLE account (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  agroup TEXT NOT NULL,
  type TEXT NOT NULL,
  initial_balance REAL NOT NULL,
  UNIQUE (name, agroup)
);

INSERT INTO account (name, agroup, type, initial_balance) VALUES ('Checking', 'My Bank', 'bank', '1000.00');

CREATE VIEW account_view AS
SELECT
  account.id AS 'ID',
  account.name AS 'Name',
  account.agroup AS 'Group',
  account.type AS 'Type',
  account.initial_balance AS 'Initial Balance'
FROM account
ORDER BY 'Type' ASC, 'Group' ASC, 'Name' ASC;

-- Envelope
CREATE TABLE envelope (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  budget REAL NOT NULL
);

INSERT INTO envelope (name, budget) VALUES ('shopping', '100.00');

CREATE VIEW envelope_view AS
SELECT
  envelope.id AS 'ID',
  envelope.name AS 'Name',
  envelope.budget AS 'Budget'
FROM envelope
ORDER BY 'Name' ASC;
