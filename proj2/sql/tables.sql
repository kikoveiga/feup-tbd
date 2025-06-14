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

-- Periods (relational)
CREATE TABLE Periods (
    periodId   VARCHAR2(10) PRIMARY KEY,
    year       NUMBER,
    quarter    NUMBER,
    CHECK (
      (quarter IS NULL AND year IS NOT NULL) OR
      (quarter BETWEEN 1 AND 4 AND year IS NOT NULL)
    )
);

-- Municipalities (subtable of GeoEntities with nested collections)
CREATE TABLE Municipalities OF Municipality_T
  OBJECT ID PRIMARY KEY
  NESTED TABLE expenses STORE AS MUN_EXPENSES_NT
  NESTED TABLE revenues STORE AS MUN_REVENUES_NT;

-- Leaderships table
CREATE TABLE Leaderships (
    code       VARCHAR2(10),
    periodId   VARCHAR2(10),
    party      REF Party_T,
    PRIMARY KEY (code, periodId),
    FOREIGN KEY (periodId) REFERENCES Periods(periodId)
);