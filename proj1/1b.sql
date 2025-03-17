select partidos.sigla, partidos.designacao, listas.mandatos
from partidos, listas, distritos
where distritos.nome = 'Lisboa' and distritos.codigo = listas.distrito and partidos.sigla = listas.partido
order by listas.mandatos desc