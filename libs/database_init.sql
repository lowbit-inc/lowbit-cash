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

CREATE VIEW account_view AS
SELECT
  account.id AS 'ID',
  account.name AS 'Name',
  account.agroup AS 'Group',
  account.type AS 'Type',
  account.initial_balance AS 'Initial Balance'
FROM account
ORDER BY 'Name' ASC, 'Group' ASC, 'Type' ASC;

-- Envelope
CREATE TABLE envelope (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  budget REAL NOT NULL
);

CREATE VIEW envelope_view AS
SELECT
  envelope.id AS 'ID',
  envelope.name AS 'Name',
  envelope.budget AS 'Budget'
FROM envelope
ORDER BY 'Name' ASC;

-- Transactions
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER,
  envelope_id INTEGER,
  date TEXT NOT NULL,
  amount REAL NOT NULL,
  description TEXT,
  FOREIGN KEY (account_id) REFERENCES account (id),
  FOREIGN KEY (envelope_id) REFERENCES envelope (id)
);

CREATE VIEW transactions_view AS
SELECT
  transactions.id AS 'ID',
  account.name AS 'Account',
  account.agroup AS 'Group',
  envelope.name AS 'Envelope',
  transactions.date AS 'Date',
  transactions.amount AS 'Amount',
  transactions.description AS 'Description'
FROM transactions
INNER JOIN account
  ON transactions.account_id = account.id
INNER JOIN envelope
  ON transactions.envelope_id = envelope.id
ORDER BY
  'Date' ASC;