--Questão 4
--a)
SELECT
    m.name              AS municipio,
    b.period.year       AS ano,
    h.description       AS heading,
    SUM(b.amount)       AS total_despesa,
    m.population        AS habitantes
FROM
    Municipalities m
    JOIN TABLE(m.budgets) b ON 1 = 1
    JOIN Headings h         ON b.heading = REF(h)
WHERE
    b.entryType = 'D'
GROUP BY
    m.name,
    b.period.year,
    h.description,
    m.population
ORDER BY
    m.population DESC;

--b)
SELECT
    m.name                           AS municipio,
    b.period.year                    AS ano,
    h.id                             AS heading_pai,
    h.description                    AS descricao_pai,
    ROUND(SUM(b.amount), 2)          AS montante_pai,
    ROUND(SUM(cb.amount), 2)         AS soma_filhos,
    ROUND(SUM(b.amount) -            -- diferença
          SUM(cb.amount), 2)         AS dif
FROM
    Municipalities m
    /* entradas orçamentais do município */
    , TABLE(m.budgets) b
    /* heading da própria entrada */
    , Headings h
    /* headings-filho do heading actual */
    , Headings c
    /* entradas orçamentais correspondentes aos filhos */
    , TABLE(m.budgets) cb
WHERE
        b.heading      = REF(h)           -- heading pai
    AND c.parent      = REF(h)           -- encontrar filhos
    AND cb.heading    = REF(c)           -- budgets dos filhos
    AND cb.entryType  = b.entryType      -- tipo D ou R deve coincidir
    AND cb.period.year = b.period.year   -- mesmo ano
    AND h.children IS NOT NULL           -- só headings com filhos
GROUP BY
    m.name,
    b.period.year,
    h.id,
    h.description
HAVING
    ROUND(SUM(b.amount) - SUM(cb.amount), 2) <> 0     -- diferença detectada
ORDER BY
    municipio,
    ano,
    heading_pai;

--c)
SELECT
    p.acronym                                       AS partido,
    h.description                                   AS heading,
    ROUND(
      AVG( m.expenses_per_1000_inhabitants(
              Period_T(2023,'ANUAL'),               -- período analisado
              REF(h)                                -- filtra heading
          )
      ), 2)                                         AS despesa_media_€/1000hab
FROM
         Municipalities   m
CROSS JOIN Headings       h                         -- percorre todos os headings
JOIN     TABLE(m.leaderships) l                     -- expande liderança
           ON l.period.year = 2023                  -- mesmo ano
JOIN     Parties          p
           ON l.party = REF(p)                      -- partido no poder
WHERE
      h.type = 'D'                                  -- apenas despesas
GROUP BY
      p.acronym,
      h.description
ORDER BY
      p.acronym,
      h.description;

--d)
WITH inv_party AS (
  SELECT
      l.period.year                                AS ano,
      p.acronym                                    AS partido,
      SUM(m.total_investment_per_km2(l.period) * m.area) AS inv_total,   -- euros
      SUM(m.area)                                  AS area_total         -- km2
  FROM
       Municipalities m
  JOIN TABLE(m.leaderships) l
       ON 1 = 1  -- required dummy ON for CROSS JOIN semantics
  JOIN TABLE(m.budgets) b
       ON b.period.year = l.period.year
  JOIN Parties p
       ON l.party = REF(p)
  GROUP BY
       l.period.year,
       p.acronym
)
SELECT ano,
       partido,
       ROUND(inv_total / area_total, 2) AS investimento_por_km2
FROM (
  SELECT
      inv_party.*,
      RANK() OVER (
        PARTITION BY ano
        ORDER BY inv_total / area_total DESC
      ) AS rnk
  FROM inv_party
)
WHERE rnk = 1
ORDER BY ano;

--e)
WITH sal_party AS (
  SELECT
      l.period.year                                    AS ano,
      p.acronym                                        AS partido,
      AVG(
        m.expenses_per_1000_inhabitants(
          Period_T(l.period.year, l.period.quarter),
          (SELECT REF(h)
             FROM Headings h
            WHERE h.id LIKE 'SAL%')
        )
      ) AS sal_por_1000
  FROM
       Municipalities m
  JOIN TABLE(m.leaderships) l
       ON 1 = 1
  JOIN TABLE(m.budgets) b
       ON b.period.year = l.period.year
  JOIN Parties p
       ON l.party = REF(p)
  WHERE l.period.quarter = 'ANUAL'
  GROUP BY
       l.period.year,
       p.acronym
)
SELECT
    ano,
    partido,
    ROUND(sal_por_1000, 2)  AS salarios_por_1000_habitantes
FROM (
    SELECT
        sal_party.*,
        RANK() OVER (
          PARTITION BY ano
          ORDER BY sal_por_1000 DESC
        ) AS rnk
    FROM sal_party
)
WHERE rnk = 1
ORDER BY ano;

--f) A query devolve, para cada município com despesas de investimento registadas em 2023, os seguintes dados: o nome do município;
-- o total de despesas no ano de 2023; o nome do partido que governa esse município nesse ano; a despesa total por 1 000 habitantes;
-- o investimento por quilómetro quadrado.

SELECT
    m.name                                                AS municipio,
    m.total_expenses( Period_T(2023,'ANUAL') )            AS despesa_total,
    DEREF( m.get_governing_party(Period_T(2023,'ANUAL')) ).partyName
                                                          AS partido_2023,
    m.expenses_per_1000_inhabitants( Period_T(2023,'ANUAL') )
                                                          AS despesa_por_1000habitantes,
    m.total_investment_per_km2( Period_T(2023,'ANUAL') )  AS inv_por_km2
FROM
    Municipalities m
WHERE
    EXISTS (
      SELECT 1
      FROM TABLE(m.budgets) b
      WHERE b.heading = (
        SELECT REF(h)
        FROM Headings h
        WHERE h.id LIKE 'INV%'
      )
    )
ORDER BY
    inv_por_km2 DESC;

