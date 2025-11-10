-- System
CREATE TABLE meta (
  name TEXT UNIQUE,
  value TEXT
);

-- Account
CREATE TABLE account (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  place TEXT NOT NULL,
  type TEXT NOT NULL,
  initial_balance REAL NOT NULL,
  UNIQUE (name, place)
);
