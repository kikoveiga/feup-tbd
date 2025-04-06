-- double negation, no view
SELECT c.codigo, p.sigla
FROM zconcelhos c
JOIN zdistritos d ON d.codigo = c.distrito
JOIN zpartidos p ON 1 = 1
WHERE d.nome = 'Porto'
  AND NOT EXISTS (
    SELECT 1
    FROM zfreguesias f
    WHERE f.concelho = c.codigo
      AND NOT EXISTS (
        SELECT 1
        FROM zvotacoes v
        WHERE v.freguesia = f.codigo
          AND v.partido = p.sigla
          AND v.votos = (
            SELECT MAX(v2.votos)
            FROM zvotacoes v2
            WHERE v2.freguesia = f.codigo
          )
      )
  );

-- count, no view
SELECT c.codigo, v.partido
FROM zdistritos d
JOIN zconcelhos c ON d.codigo = c.distrito
JOIN zfreguesias f ON c.codigo = f.concelho
JOIN zvotacoes v ON f.codigo = v.freguesia
WHERE d.nome = 'Porto'
  AND v.votos = (
    SELECT MAX(v2.votos)
    FROM zvotacoes v2
    WHERE v2.freguesia = f.codigo
  )
GROUP BY c.codigo, v.partido
HAVING COUNT(DISTINCT f.codigo) = (
  SELECT COUNT(*)
  FROM zfreguesias f2
  WHERE f2.concelho = c.codigo
)
ORDER BY c.codigo, v.partido;

-- create view
CREATE OR REPLACE VIEW vw_vencedores_freguesia AS
SELECT v.freguesia, v.partido
FROM zvotacoes v
WHERE v.votos = (
  SELECT MAX(v2.votos)
  FROM zvotacoes v2
  WHERE v2.freguesia = v.freguesia
);

-- drop view
DROP VIEW vw_vencedores_freguesia;

-- double negation, with view
SELECT c.codigo, p.sigla
FROM zconcelhos c
JOIN zdistritos d ON d.codigo = c.distrito
JOIN zpartidos p ON 1 = 1
WHERE d.nome = 'Porto'
  AND NOT EXISTS (
    SELECT 1
    FROM zfreguesias f
    WHERE f.concelho = c.codigo
      AND NOT EXISTS (
        SELECT 1
        FROM vw_vencedores_freguesia vw
        WHERE vw.freguesia = f.codigo
          AND vw.partido = p.sigla
      )
  );

-- count, with view
SELECT c.codigo, vw.partido
FROM zdistritos d
JOIN zconcelhos c ON d.codigo = c.distrito
JOIN zfreguesias f ON c.codigo = f.concelho
JOIN vw_vencedores_freguesia vw ON f.codigo = vw.freguesia
WHERE d.nome = 'Porto'
GROUP BY c.codigo, vw.partido
HAVING COUNT(DISTINCT f.codigo) = (
  SELECT COUNT(*)
  FROM zfreguesias f2
  WHERE f2.concelho = c.codigo
)
ORDER BY c.codigo, vw.partido;

-- create materialized view
CREATE MATERIALIZED VIEW mv_vencedores_freguesia
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT v.freguesia, v.partido
FROM zvotacoes v
WHERE v.votos = (
  SELECT MAX(v2.votos)
  FROM zvotacoes v2
  WHERE v2.freguesia = v.freguesia
);

-- double negation, with materialized view
SELECT c.codigo, p.sigla
FROM zconcelhos c
JOIN zdistritos d ON d.codigo = c.distrito
JOIN zpartidos p ON 1 = 1
WHERE d.nome = 'Porto'
  AND NOT EXISTS (
    SELECT 1
    FROM zfreguesias f
    WHERE f.concelho = c.codigo
      AND NOT EXISTS (
        SELECT 1
        FROM mv_vencedores_freguesia mv
        WHERE mv.freguesia = f.codigo
          AND mv.partido = p.sigla
      )
  );

-- count, with materialized view
SELECT c.codigo, mv.partido
FROM zdistritos d
JOIN zconcelhos c ON d.codigo = c.distrito
JOIN zfreguesias f ON c.codigo = f.concelho
JOIN mv_vencedores_freguesia mv ON f.codigo = mv.freguesia
WHERE d.nome = 'Porto'
GROUP BY c.codigo, mv.partido
HAVING COUNT(DISTINCT f.codigo) = (
  SELECT COUNT(*)
  FROM zfreguesias f2
  WHERE f2.concelho = c.codigo
)
ORDER BY c.codigo, mv.partido;