select nome, designacao, votos
from (

select distritos.nome, partidos.designacao, SUM(votacoes.votos) AS votos, MAX(SUM(votacoes.votos)) OVER (PARTITION BY distritos.nome) AS max_votos
from distritos, concelhos, freguesias, votacoes, partidos
where distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = partidos.sigla
group by distritos.nome, partidos.designacao

)
where votos = max_votos
order by votos desc

-- Ambiente X
select nome, designacao, votos
from (

select xdistritos.nome, xpartidos.designacao, SUM(xvotacoes.votos) AS votos, MAX(SUM(xvotacoes.votos)) OVER (PARTITION BY xdistritos.nome) AS max_votos
from xdistritos, xconcelhos, xfreguesias, xvotacoes, xpartidos
where xdistritos.codigo = xconcelhos.distrito and xconcelhos.codigo = xfreguesias.concelho and xfreguesias.codigo = xvotacoes.freguesia and xvotacoes.partido = xpartidos.sigla
group by xdistritos.nome, xpartidos.designacao

)
where votos = max_votos
order by votos desc

-- Ambiente Y
select nome, designacao, votos
from (

select ydistritos.nome, ypartidos.designacao, SUM(yvotacoes.votos) AS votos, MAX(SUM(yvotacoes.votos)) OVER (PARTITION BY ydistritos.nome) AS max_votos
from ydistritos, yconcelhos, yfreguesias, yvotacoes, ypartidos
where ydistritos.codigo = yconcelhos.distrito and yconcelhos.codigo = yfreguesias.concelho and yfreguesias.codigo = yvotacoes.freguesia and yvotacoes.partido = ypartidos.sigla
group by ydistritos.nome, ypartidos.designacao

)
where votos = max_votos
order by votos desc

-- Ambiente Z
select nome, designacao, votos
from (

select zdistritos.nome, zpartidos.designacao, SUM(zvotacoes.votos) AS votos, MAX(SUM(zvotacoes.votos)) OVER (PARTITION BY zdistritos.nome) AS max_votos
from zdistritos, zconcelhos, zfreguesias, zvotacoes, zpartidos
where zdistritos.codigo = zconcelhos.distrito and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia and zvotacoes.partido = zpartidos.sigla
group by zdistritos.nome, zpartidos.designacao

)
where votos = max_votos
order by votos desc