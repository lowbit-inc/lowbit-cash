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
  reconciled INTEGER,
  reconciled_balance REAL,
  reconciled_date TEXT,
  UNIQUE (name, agroup)
);

CREATE TABLE envelope (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  egroup TEXT NOT NULL,
  type TEXT NOT NULL,
  budget REAL,
  UNIQUE (name, egroup)
);

INSERT INTO envelope (id, name, egroup, type) VALUES (1, 'Unallocated', 'Reserved', '--');

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
  account.agroup AS 'Group',
  account.name AS 'Name',
  account.type AS 'Type',
  COALESCE(SUM(transactions.amount), 0.00) AS 'Balance',
  iif(account.reconciled, 'True', 'False') AS 'Reconciled?',
  account.reconciled_date AS 'Reconciled Date',
  account.reconciled_balance AS 'Reconciled Balance'
FROM
  account
LEFT JOIN
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
  envelope.egroup AS 'Group',
  envelope.name AS 'Name',
  envelope.type AS 'Type',
  envelope.budget AS 'Budget',
  COALESCE(SUM(transactions.amount), 0.00) AS 'Balance'
FROM
  envelope
LEFT JOIN
  transactions ON transactions.envelope_id = envelope.id
GROUP BY
  envelope.id
ORDER BY
  envelope.type DESC, envelope.egroup ASC, envelope.name ASC;

CREATE VIEW transactions_view AS
SELECT
  transactions.id AS 'ID',
  account.agroup AS 'Account Group',
  account.name AS 'Account Name',
  envelope.egroup AS 'Envelope Group',
  envelope.name AS 'Envelope Name',
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
