CREATE TYPE Period_T AS OBJECT (
  year    NUMBER(4),
  quarter CHAR(1) -- '1', '2', '3', '4'
);
/

-- Political parties
CREATE TYPE Party_T AS OBJECT (
    acronym VARCHAR2(10),
    partyName VARCHAR2(100),
    spectrum VARCHAR2(50)
); 
/

-- Forward declaration
CREATE TYPE Heading_T;
/
CREATE TYPE Heading_RefList_T AS TABLE OF REF Heading_T;
/

CREATE TYPE Heading_T AS OBJECT (
  id          VARCHAR2(15),
  description VARCHAR2(120),
  type        CHAR(1),        -- 'D' (expense) or 'R' (revenue)
  hlevel      NUMBER(2),
  parent      REF Heading_T,
  children    Heading_RefList_T
);
/

-- Budget entry (expenses & revenues)
CREATE TYPE BudgetEntry_T AS OBJECT (
  entryType CHAR(1), -- 'D' (expense) or 'R' (revenue)
  period   Period_T,
  amount   NUMBER(14,2),
  heading  REF Heading_T
) NOT FINAL;
/

CREATE TYPE BudgetList_T   AS TABLE OF BudgetEntry_T;
/  

-- Leaderships
CREATE TYPE Leadership_T AS OBJECT (
  period  Period_T,
  party   REF Party_T
);
/
CREATE TYPE LeadershipList_T AS TABLE OF Leadership_T;
/

-- Abstract geographic entity
CREATE TYPE GeoEntity_T AS OBJECT (
    code        VARCHAR2(10),
    name        VARCHAR2(100),
    area        NUMBER,
    population  NUMBER,
    geoLevel    VARCHAR2(20), -- 'country', 'NUTS I', 'NUTS II', 'NUTS III', 'municipality'
    parent      REF GeoEntity_T
) NOT FINAL;
/

CREATE TYPE Municipality_T AS OBJECT (
  code         VARCHAR2(10),
  name         VARCHAR2(100),
  area         NUMBER,
  population   NUMBER,
  geoLevel     VARCHAR2(20),
  parent       REF GeoEntity_T,

  -- Additional fields specific to municipalities
  budgets      BudgetList_T,
  leaderships  LeadershipList_T,

  -- Methods
  MEMBER FUNCTION total_expenses (p Period_T) RETURN NUMBER,
  MEMBER FUNCTION per_capita    (p Period_T) RETURN NUMBER
);
/