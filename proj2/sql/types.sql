-- 1. Period
CREATE TYPE Period_T AS OBJECT (
  year    NUMBER(4),
  quarter CHAR(1)        -- '1','2','3','4'
);
/


-- 2. Party
CREATE TYPE Party_T AS OBJECT (
  acronym    VARCHAR2(15),
  partyName  VARCHAR2(50),
  spectrum   VARCHAR2(20)
);
/


-- 3. Heading with hierarchy
CREATE TYPE Heading_T;                           -- forward
CREATE TYPE Heading_RefList_T AS TABLE OF REF Heading_T;
/  
CREATE TYPE Heading_T AS OBJECT (
  id          VARCHAR2(15),
  description VARCHAR2(120),
  type        CHAR(1),        -- 'D' or 'R'
  hlevel      NUMBER(2),
  parent      REF Heading_T,
  children    Heading_RefList_T
);
/


-- 4. Budget entry (expenses & revenues)
CREATE TYPE BudgetEntry_T AS OBJECT (
  period   Period_T,
  amount   NUMBER(14,2),
  heading  REF Heading_T
) NOT FINAL;
/


-- (Opcional) subtipo para despesas:
CREATE TYPE Expense_T UNDER BudgetEntry_T;
/  
-- (Opcional) subtipo para receitas:
CREATE TYPE Revenue_T UNDER BudgetEntry_T;
/


-- 5. Collections for budgets
CREATE TYPE BudgetList_T   AS TABLE OF BudgetEntry_T;
/  
CREATE TYPE ExpenseList_T  AS TABLE OF Expense_T;    -- se usares subtipo
CREATE TYPE RevenueList_T  AS TABLE OF Revenue_T;    -- se usares subtipo
/


-- 6. Leadership history
CREATE TYPE Leadership_T AS OBJECT (
  period  Period_T,
  party   REF Party_T
);
/  
CREATE TYPE LeadershipList_T AS TABLE OF Leadership_T;
/


-- 7. Geo-entity supertype
CREATE TYPE GeoEntity_T AS OBJECT (
  code        VARCHAR2(10),
  name        VARCHAR2(100),
  area        NUMBER,
  population  NUMBER,
  geoLevel    VARCHAR2(20),  -- 'country','NUTS I','NUTS II','NUTS III','municipality'
  parent      REF GeoEntity_T
) NOT FINAL;
/


-- 8. Municipality subtype
CREATE TYPE Municipality_T UNDER GeoEntity_T (
  budgets      BudgetList_T,
  leaderships  LeadershipList_T,

  -- Métodos exemplares
  MEMBER FUNCTION total_expenses (p Period_T) RETURN NUMBER,
  MEMBER FUNCTION per_capita    (p Period_T) RETURN NUMBER
);
/ 