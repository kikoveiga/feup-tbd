select concelhos.codigo, votacoes.partido
from distritos, concelhos, freguesias, votacoes
where distritos.nome = 'Porto' and distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia
and votacoes.votos = (
    select max(votacoes.votos)
    from votacoes
    where votacoes.freguesia = freguesias.codigo
)
group by concelhos.codigo, votacoes.partido
having count(distinct freguesias.codigo) = (
    select count(*)
    from freguesias
    where freguesias.concelho = concelhos.codigo
)
order by concelhos.codigo, votacoes.partido
    
-- Ambiente X
select xconcelhos.codigo, xvotacoes.partido
from xdistritos, xconcelhos, xfreguesias, xvotacoes
where xdistritos.nome = 'Porto' and xdistritos.codigo = xconcelhos.distrito and xconcelhos.codigo = xfreguesias.concelho and xfreguesias.codigo = xvotacoes.freguesia
and xvotacoes.votos = (
    select max(xvotacoes.votos)
    from xvotacoes
    where xvotacoes.freguesia = xfreguesias.codigo
)
group by xconcelhos.codigo, xvotacoes.partido
having count(distinct xfreguesias.codigo) = (
    select count(*)
    from xfreguesias
    where xfreguesias.concelho = xconcelhos.codigo
)
order by xconcelhos.codigo, xvotacoes.partido

-- Ambiente Y
select yconcelhos.codigo, yvotacoes.partido
from ydistritos, yconcelhos, yfreguesias, yvotacoes
where ydistritos.nome = 'Porto' and ydistritos.codigo = yconcelhos.distrito and yconcelhos.codigo = yfreguesias.concelho and yfreguesias.codigo = yvotacoes.freguesia
and yvotacoes.votos = (
    select max(yvotacoes.votos)
    from yvotacoes
    where yvotacoes.freguesia = yfreguesias.codigo
)
group by yconcelhos.codigo, yvotacoes.partido
having count(distinct yfreguesias.codigo) = (
    select count(*)
    from yfreguesias
    where yfreguesias.concelho = yconcelhos.codigo
)
order by yconcelhos.codigo, yvotacoes.partido

-- Ambiente Z
select zconcelhos.codigo, zvotacoes.partido
from zdistritos, zconcelhos, zfreguesias, zvotacoes
where zdistritos.nome = 'Porto' and zdistritos.codigo = zconcelhos.distrito and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia
and zvotacoes.votos = (
    select max(zvotacoes.votos)
    from zvotacoes
    where zvotacoes.freguesia = zfreguesias.codigo
)
group by zconcelhos.codigo, zvotacoes.partido
having count(distinct zfreguesias.codigo) = (
    select count(*)
    from zfreguesias
    where zfreguesias.concelho = zconcelhos.codigo
)
order by zconcelhos.codigo, zvotacoes.partido