select distritos.nome, partidos.designacao, sum(votacoes.votos) as votos
from distritos, concelhos, freguesias, votacoes, partidos
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = partidos.sigla
group by distritos.nome, partidos.designacao
order by distritos.nome, votos desc

-- Ambiente X
select xdistritos.nome, xpartidos.designacao, sum(xvotacoes.votos) as votos
from xdistritos, xconcelhos, xfreguesias, xvotacoes, xpartidos
where xdistritos.codigo = xconcelhos.distrito and xconcelhos.codigo = xfreguesias.concelho and xfreguesias.codigo = xvotacoes.freguesia and xvotacoes.partido = xpartidos.sigla
group by xdistritos.nome, xpartidos.designacao
order by xdistritos.nome, votos desc

-- Ambiente Y
select ydistritos.nome, ypartidos.designacao, sum(yvotacoes.votos) as votos
from ydistritos, yconcelhos, yfreguesias, yvotacoes, ypartidos
where ydistritos.codigo = yconcelhos.distrito and yconcelhos.codigo = yfreguesias.concelho and yfreguesias.codigo = yvotacoes.freguesia and yvotacoes.partido = ypartidos.sigla
group by ydistritos.nome, ypartidos.designacao
order by ydistritos.nome, votos desc

-- Ambiente Z
select zdistritos.nome, zpartidos.designacao, sum(zvotacoes.votos) as votos
from zdistritos, zconcelhos, zfreguesias, zvotacoes, zpartidos
where zdistritos.codigo = zconcelhos.distrito and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia and zvotacoes.partido = zpartidos.sigla
group by zdistritos.nome, zpartidos.designacao
order by zdistritos.nome, votos desc