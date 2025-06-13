-- Parties
CREATE TABLE Parties OF Party_T
  OBJECT ID PRIMARY KEY;

-- Headings
CREATE TABLE Headings OF Heading_T
  OBJECT ID PRIMARY KEY
  CHECK (type IN ('D', 'R'));

-- GeoEntities (countries, NUTS, municipalities)
CREATE TABLE GeoEntities OF GeoEntity_T
  OBJECT ID PRIMARY KEY
  CHECK (geoLevel IN ('country', 'NUTS I', 'NUTS II', 'NUTS III', 'municipality'));

-- Periods (not object-based for now, just relational)
CREATE TABLE Periods (
    periodId   VARCHAR2(10) PRIMARY KEY,
    year       NUMBER,
    quarter    NUMBER
);

-- AExpenses and ARevenues can be used as nested tables or standalone tables
-- If standalone:
CREATE TABLE AExpenses OF AExpense_T
  OBJECT ID PRIMARY KEY;

CREATE TABLE ARevenues OF ARevenue_T
  OBJECT ID PRIMARY KEY;

-- Leaderships table
CREATE TABLE Leaderships (
    code       VARCHAR2(10),
    periodId   VARCHAR2(10),
    party      REF Party_T,
    PRIMARY KEY (code, periodId)
);