select zvotacoes.partido, zconcelhos.distrito, sum (zvotacoes.votos) as votos
from zvotacoes, zconcelhos, zfreguesias
where zvotacoes.partido in ('PS', 'PPDPSD') and zconcelhos.distrito in (11, 15, 17) and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia
group by zvotacoes.partido, zconcelhos.distrito
order by votos desc
