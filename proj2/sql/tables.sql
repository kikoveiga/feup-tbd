-- 1. Parties
CREATE TABLE Parties OF Party_T
  OBJECT ID PRIMARY KEY;

-- 2. Headings
CREATE TABLE Headings OF Heading_T
  OBJECT ID PRIMARY KEY
  CHECK (type IN ('D','R'))
  NESTED TABLE children STORE AS Heading_Children_NT;

-- 3. Geo-entities (país, NUTS I/II/III e municípios)
CREATE TABLE GeoEntities OF GeoEntity_T
  OBJECT ID PRIMARY KEY
  CHECK (geoLevel IN ('country','NUTS I','NUTS II','NUTS III','municipality'))
  SCOPE FOR (parent) IS GeoEntities;

-- 4. Municipalities (subtipo de GeoEntity_T)  
--    inclui nested budgets e leaderships  
CREATE TABLE Municipalities OF Municipality_T
  OBJECT ID PRIMARY KEY
  CHECK (geoLevel = 'municipality')
  SCOPE FOR (parent) IS GeoEntities
  NESTED TABLE budgets     STORE AS Mun_Budgets_NT
  NESTED TABLE leaderships STORE AS Mun_Leaderships_NT;