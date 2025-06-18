CREATE OR REPLACE TYPE BODY Municipality_T AS

  MEMBER FUNCTION total_expenses (
    p_period   Period_T,
    p_heading  REF Heading_T DEFAULT NULL
  ) RETURN NUMBER IS
    total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(b.amount), 0)
    INTO total
    FROM TABLE(SELF.budgets) b
    WHERE b.entryType = 'D' AND 
          b.period.year = p_period.year AND
          (p_heading IS NULL OR b.heading = p_heading);
    RETURN total;
  END;

  MEMBER FUNCTION expenses_per_1000_inhabitants (
    p_period   Period_T,
    p_heading  REF Heading_T DEFAULT NULL
  ) RETURN NUMBER IS
    total NUMBER;
  BEGIN
    total := SELF.total_expenses(p_period, p_heading);
    IF SELF.population > 0 THEN
      RETURN (total / SELF.population) * 1000;
    ELSE
      RETURN NULL;
    END IF;
  END;

  MEMBER FUNCTION total_investment_per_km2 (
    p_period   Period_T
  ) RETURN NUMBER IS
    total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(b.amount), 0)
    INTO total
    FROM TABLE(SELF.budgets) b
    WHERE b.entryType = 'D' AND 
          b.period.year = p_period.year AND
          EXISTS (
            SELECT 1 FROM Headings h
            WHERE h.id LIKE 'D2%' AND b.heading = REF(h)
          );
    IF SELF.area > 0 THEN
      RETURN total / SELF.area;
    ELSE
      RETURN NULL;
    END IF;
  END;

  MEMBER FUNCTION total_revenues (
    p_period   Period_T,
    p_heading  REF Heading_T DEFAULT NULL
  ) RETURN NUMBER IS
    total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(b.amount), 0)
    INTO total
    FROM TABLE(SELF.budgets) b
    WHERE b.entryType = 'R' AND 
          b.period.year = p_period.year AND
          (p_heading IS NULL OR b.heading = p_heading);
    RETURN total;
  END;

  MEMBER FUNCTION net_balance (
    p_period   Period_T
  ) RETURN NUMBER IS
    revenues NUMBER;
    expenses NUMBER;
  BEGIN
    revenues := SELF.total_revenues(p_period);
    expenses := SELF.total_expenses(p_period);
    RETURN revenues - expenses;
  END;

  MEMBER FUNCTION get_governing_party (
    p_period Period_T
  ) RETURN REF Party_T IS
    p REF Party_T;
  BEGIN
    FOR i IN 1 .. SELF.leaderships.COUNT LOOP
      IF SELF.leaderships(i).period.year = p_period.year THEN
        RETURN SELF.leaderships(i).party;
      END IF;
    END LOOP;
    RETURN NULL;
  END;

  MEMBER FUNCTION is_governed_by (
    party REF Party_T,
    p_period Period_T
  ) RETURN BOOLEAN IS
  BEGIN
    FOR i IN 1 .. SELF.leaderships.COUNT LOOP
      IF SELF.leaderships(i).period.year = p_period.year AND
         SELF.leaderships(i).party = party THEN
        RETURN TRUE;
      END IF;
    END LOOP;
    RETURN FALSE;
  END;

  MEMBER FUNCTION has_heading (
    p_heading REF Heading_T
  ) RETURN BOOLEAN IS
  BEGIN
    FOR i IN 1 .. SELF.budgets.COUNT LOOP
      IF SELF.budgets(i).heading = p_heading THEN
        RETURN TRUE;
      END IF;
    END LOOP;
    RETURN FALSE;
  END;

END;
/
