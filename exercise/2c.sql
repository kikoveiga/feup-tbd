select distritos.nome, partidos.designacao
from distritos, concelhos, freguesias, votacoes, partidos
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = partidos.sigla
group by 