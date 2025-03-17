select nome, max(votos) as votos from (

select distritos.nome as nome, votacoes.partido as partido, sum(votacoes.votos) as votos
from distritos, concelhos, freguesias, votacoes
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia
group by distritos.nome, votacoes.partido
order by votos desc

)
group by nome
order by votos desc


-- not finished, need to add partido to the select