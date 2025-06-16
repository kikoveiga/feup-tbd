--Questão 4
--a)
SELECT
    r.name                                    AS regiao_nuts1,
    m.name                                    AS municipio,
    p.year                                    AS ano,
    h.description                             AS heading,
    SUM(b.amount)                             AS total_despesa,
    m.population                              AS habitantes
FROM
    Municipalities m
      -- expandir a nested table budgets
      , TABLE(m.budgets) b
      , Headings h
      , GeoEntities r
      , Period_T p
WHERE
      b.entryType      = 'D'              -- só despesas
  AND b.heading        = REF(h)           -- liga à categoria
  AND m.parent         = REF(r)           -- r = entidade geográfica ascendente
  AND r.geoLevel       = 'NUTS I'         -- apenas nível de região
  -- criar objecto-período “on-the-fly” para comparar (ano)
  AND b.period.year    = p.year
GROUP BY
    r.name,
    m.name,
    p.year,
    h.description,
    m.population
ORDER BY
    r.name,
    m.population DESC;      -- municípios mais populosos primeiro

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
      SUM(  m.total_investment_per_km2(l.period) 
         *  m.area )                               AS inv_total,   -- euros
      SUM( m.area )                                AS area_total   -- km2
  FROM
         Municipalities  m
  JOIN   TABLE(m.leaderships) l
         ON l.period.year = m.budgets(1).period.year  -- simplificação se usas ANUAL
  JOIN   Parties p
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
      RANK() OVER (PARTITION BY ano
                   ORDER BY inv_total / area_total DESC) AS rnk
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
          Period_T(l.period.year, l.period.quarter),   -- ano (ou 'ANUAL')
          -- referência ao heading de salários:
          (SELECT REF(h)
             FROM Headings h
            WHERE h.id LIKE 'SAL%')
        )
      ) AS sal_por_1000
  FROM
         Municipalities m
  JOIN   TABLE(m.leaderships) l
           ON l.period.year = m.budgets(1).period.year   -- usa o mesmo ano
  JOIN   Parties p
           ON l.party = REF(p)
  WHERE  l.period.quarter = 'ANUAL'                      -- se usas períodos anuais
  GROUP BY
         l.period.year,
         p.acronym
)
SELECT
    ano,
    partido,
    ROUND(sal_por_1000, 2)  AS salarios_€/1000hab
FROM (
    SELECT
        sal_party.*,
        RANK() OVER (PARTITION BY ano
                     ORDER BY sal_por_1000 DESC) AS rnk
    FROM sal_party
)
WHERE rnk = 1
ORDER BY ano;

--f) A query devolve, para cada município com despesas de investimento registadas em 2023, os seguintes dados: o nome do município;
-- o total de despesas no ano de 2023; o nome do partido que governa esse município nesse ano; a despesa total por 1 000 habitantes;
-- o investimento por quilómetro quadrado.

SELECT
    m.name                                                AS municipio,
    /* 1) método: total de despesas no ano 2023            */
    m.total_expenses( Period_T(2023,'ANUAL') )            AS despesa_total,
    /* 2) desreferenciação directa do partido no poder     */
    DEREF( m.get_governing_party(Period_T(2023,'ANUAL')) ).partyName
                                                          AS partido_2023,
    /* 3) outro método: despesa por 1 000 hab.             */
    m.expenses_per_1000_inhabitants( Period_T(2023,'ANUAL') )
                                                          AS despesa_€/1000hab,
    /* método que devolve investimento/km²                 */
    m.total_investment_per_km2( Period_T(2023,'ANUAL') )  AS inv_€/km2
FROM
    Municipalities m
WHERE
    /* usa método booleano que percorre a nested table budgets       */
    m.has_heading( (SELECT REF(h)
                    FROM   Headings h
                    WHERE  h.id LIKE 'INV%') )            -- apenas quem regista investimento
ORDER BY
    inv_€/km2 DESC;

