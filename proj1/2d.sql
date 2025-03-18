select nome, designacao, votos
from (

select distritos.nome, partidos.designacao, SUM(votacoes.votos) AS votos, MAX(SUM(votacoes.votos)) OVER (PARTITION BY distritos.nome) AS max_votos
from distritos, concelhos, freguesias, votacoes, partidos
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = partidos.sigla
group by distritos.nome, partidos.designacao

)
where votos = max_votos
order by votos desc
