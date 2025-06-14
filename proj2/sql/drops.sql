-- === DROP TABLES (reverse dependency order) ===
BEGIN
  FOR tbl IN (
    SELECT table_name FROM user_tables
    WHERE table_name IN (
      'MUNICIPALITIES',
      'GEO_ENTITIES',
      'HEADINGS',
      'PARTIES'
    )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || tbl.table_name || ' CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
  END LOOP;
END;
/
SET SERVEROUTPUT ON;


-- === DROP TYPES (reverse dependency order) ===

DECLARE
  PROCEDURE try_drop(p_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE ' || p_name || ' FORCE';
    DBMS_OUTPUT.PUT_LINE('Dropped type ' || p_name);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -4043 THEN
        DBMS_OUTPUT.PUT_LINE('Type ' || p_name || ' does not exist (skipped).');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Failed to drop ' || p_name || ': ' || SQLERRM);
      END IF;
  END;
BEGIN
  -- leaf collection types
  try_drop('HEADING_REFLIST_T');
  try_drop('BUDGETLIST_T');
  try_drop('EXPENSELIST_T');
  try_drop('REVENUELIST_T');
  try_drop('LEADERSHIPLIST_T');

  -- subtypes
  try_drop('EXPENSE_T');
  try_drop('REVENUE_T');

  -- structural object types
  try_drop('MUNICIPALITY_T');
  try_drop('GEOENTITY_T');
  try_drop('LEADERSHIP_T');
  try_drop('BUDGETENTRY_T');
  try_drop('ANNUALRECORD_T');
  try_drop('HEADING_T');
  try_drop('PARTY_T');
  try_drop('PERIOD_T');
END;
/
