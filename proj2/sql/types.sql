-- Political parties
CREATE TYPE Party_T AS OBJECT (
    acronym VARCHAR2(10),
    partyName VARCHAR2(100),
    spectrum VARCHAR2(50)
); 
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

-- Heading for expense/revenue classification
CREATE TYPE Heading_T AS OBJECT (
    id          VARCHAR2(10),
    description VARCHAR2(100),
    type        CHAR(1), -- 'D' for expense, 'R' for revenue
    hlevel      NUMBER,
    parent      REF Heading_T
);
/

-- Base record for revenue/expense
CREATE TYPE AnnualRecord_T AS OBJECT (
    year     NUMBER,
    heading  REF Heading_T,
    amount   NUMBER
) NOT FINAL;
/

-- Subtypes for expenses and revenues
CREATE TYPE AExpense_T UNDER AnnualRecord_T ();
/
CREATE TYPE ARevenue_T UNDER AnnualRecord_T ();
/

-- Nested collections to hold revenues/expenses
CREATE TYPE ExpenseList_T AS TABLE OF AExpense_T;
/
CREATE TYPE RevenueList_T AS TABLE OF ARevenue_T;
/

CREATE TYPE Municipality_T UNDER GeoEntity_T (
    ruling_party  REF Party_T,
    expenses      ExpenseList_T,
    revenues      RevenueList_T
);