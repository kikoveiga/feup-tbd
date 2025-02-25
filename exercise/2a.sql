select sum(listas.mandatos) as membros, listas.partido
from listas, partidos
where listas.partido = partidos.sigla
group by listas.partido
order by membros desc;