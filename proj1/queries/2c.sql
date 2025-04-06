select votacoes.partido, freguesias.nome, votacoes.votos
from votacoes, freguesias
where freguesias.codigo = votacoes.freguesia
order by votacoes.votos desc
fetch first 1 row only

-- Ambiente X
select xvotacoes.partido, xfreguesias.nome, xvotacoes.votos
from xvotacoes, xfreguesias
where xfreguesias.codigo = xvotacoes.freguesia
order by xvotacoes.votos desc
fetch first 1 row only

-- Ambiente Y
select yvotacoes.partido, yfreguesias.nome, yvotacoes.votos
from yvotacoes, yfreguesias
where yfreguesias.codigo = yvotacoes.freguesia
order by yvotacoes.votos desc
fetch first 1 row only

-- Ambiente Z
select zvotacoes.partido, zfreguesias.nome, zvotacoes.votos
from zvotacoes, zfreguesias
where zfreguesias.codigo = zvotacoes.freguesia
order by zvotacoes.votos desc
fetch first 1 row only
