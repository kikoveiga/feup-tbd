-- 1. Parties
CREATE TABLE Parties OF Party_T (
  PRIMARY KEY (acronym)
);

-- 2. Headings
CREATE TABLE Headings OF Heading_T (
  PRIMARY KEY (id)
)
NESTED TABLE children STORE AS Heading_Children_NT;

ALTER TABLE Headings
  ADD CONSTRAINT chk_heading_type
  CHECK (type IN ('D','R'));

-- 3. Geo-entities (país, NUTS I/II/III e municípios)
CREATE TABLE GeoEntities OF GeoEntity_T (
  PRIMARY KEY (code)
);

ALTER TABLE GeoEntities
  ADD SCOPE FOR (parent) IS GeoEntities;

ALTER TABLE GeoEntities
  ADD CONSTRAINT chk_geo_level
  CHECK (geoLevel IN ('country','NUTS I','NUTS II','NUTS III','municipality'));

-- 4. Municipalities (subtipo de GeoEntity_T)  
--    inclui nested budgets e leaderships
CREATE TABLE Municipalities OF Municipality_T (
  PRIMARY KEY (code)
)
NESTED TABLE budgets     STORE AS Mun_Budgets_NT,
NESTED TABLE leaderships STORE AS Mun_Leaderships_NT;

ALTER TABLE Municipalities
  ADD SCOPE FOR (parent) IS GeoEntities;

ALTER TABLE Municipalities
  ADD CONSTRAINT chk_municipality_level
  CHECK (geoLevel = 'municipality');