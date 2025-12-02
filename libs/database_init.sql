-- System
CREATE TABLE meta (
  name TEXT UNIQUE,
  value TEXT
);

INSERT INTO meta VALUES ("db_schema", "1");

-- Tables
CREATE TABLE account (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  agroup TEXT NOT NULL,
  type TEXT NOT NULL,
  UNIQUE (name, agroup)
);

CREATE TABLE envelope (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  budget REAL NOT NULL
);

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

-- Views
CREATE VIEW account_view AS
SELECT
  account.id as 'ID',
  account.name AS 'Name',
  account.agroup AS 'Group',
  account.type AS 'Type',
  SUM(transactions.amount) AS 'Balance'
FROM
  account
JOIN
  transactions ON transactions.account_id = account.id
GROUP BY
  account.id
ORDER BY
  account.name ASC,
  account.agroup ASC,
  account.type ASC;

CREATE VIEW envelope_view AS
SELECT
  envelope.id AS 'ID',
  envelope.name AS 'Name',
  envelope.budget AS 'Budget',
  SUM(transactions.amount) AS 'Balance'
FROM
  envelope
LEFT JOIN
  transactions ON transactions.envelope_id = envelope.id
GROUP BY
  envelope.id
ORDER BY
  envelope.name ASC;

CREATE VIEW transactions_view AS
SELECT
  transactions.id AS 'ID',
  account.name AS 'Account',
  account.agroup AS 'Group',
  envelope.name AS 'Envelope',
  transactions.date AS 'Date',
  transactions.amount AS 'Amount',
  transactions.description AS 'Description'
FROM
  transactions
LEFT JOIN
  account ON transactions.account_id = account.id
LEFT JOIN
  envelope ON transactions.envelope_id = envelope.id
ORDER BY
  transactions.date ASC;
