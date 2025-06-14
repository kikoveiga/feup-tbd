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
  CHECK (geoLevel IN ('country', 'NUTS I', 'NUTS II', 'NUTS III', 'municipality'))
  SCOPE FOR (parent) IS GeoEntities;

-- Municipalities (subtable of GeoEntities with nested collections)
CREATE TABLE Municipalities OF Municipality_T
  OBJECT ID PRIMARY KEY
  NESTED TABLE budgets STORE AS MUN_Budgets_NT
  NESTED TABLE leaderships STORE AS MUN_Leaderships_NT;