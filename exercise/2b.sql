select distritos.nome, partidos.designacao, sum(votacoes.votos) as votos
from distritos, concelhos, freguesias, votacoes, partidos
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and partidos.sigla = votacoes.partido
group by distritos.nome, partidos.designacao
order by distritos.nome, votos desc;