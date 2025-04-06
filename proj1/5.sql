select zvotacoes.partido, zconcelhos.distrito, sum (zvotacoes.votos) as votos
from zvotacoes, zconcelhos, zfreguesias
where zvotacoes.partido in ('PS', 'PPDPSD') and zconcelhos.distrito in (11, 15, 17) and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia
group by zvotacoes.partido, zconcelhos.distrito
order by votos desc

-- b-tree indexes
CREATE INDEX idx_zconcelhos_distrito ON zconcelhos(distrito);
CREATE INDEX idx_zvotacoes_partido ON zvotacoes(partido);

-- bitmap indexes
CREATE BITMAP INDEX bm_zconcelhos_distrito ON zconcelhos(distrito);
CREATE BITMAP INDEX bm_zvotacoes_partido ON zvotacoes(partido);

-- drop indexes
DROP INDEX idx_zconcelhos_distrito;
DROP INDEX idx_zvotacoes_partido;
