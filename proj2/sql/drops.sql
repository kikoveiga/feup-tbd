-- Drop tables first (in reverse dependency order)
BEGIN
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE Leaderships'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE ARevenues';   EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE AExpenses';   EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE Periods';     EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE GeoEntities'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE Headings';    EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE Parties';     EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

-- Turn on output buffering to see messages (in SQL*Plus or SQL Developer):
SET SERVEROUTPUT ON;

-- Drop ARevenue_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE ARevenue_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type ARevenue_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type ARevenue_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop ARevenue_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop AExpense_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE AExpense_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type AExpense_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type AExpense_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop AExpense_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop AnnualRecord_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE AnnualRecord_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type AnnualRecord_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type AnnualRecord_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop AnnualRecord_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop Heading_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE Heading_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type Heading_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type Heading_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop Heading_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop Municipality_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE Municipality_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type Municipality_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type Municipality_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop Municipality_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop GeoEntity_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE GeoEntity_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type GeoEntity_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type GeoEntity_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop GeoEntity_T: ' || SQLERRM);
        END IF;
END;
/

-- Drop Party_T if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE Party_T';
    DBMS_OUTPUT.PUT_LINE('Dropped type Party_T.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('Type Party_T does not exist (skipped).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Failed to drop Party_T: ' || SQLERRM);
        END IF;
END;
/
