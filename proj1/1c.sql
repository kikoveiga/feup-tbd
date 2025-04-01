select sum(votacoes.votos) as votos_be
from votacoes, freguesias, concelhos, distritos
where distritos.nome = 'Lisboa' and distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = 'BE'

-- Ambiente X
select sum(xvotacoes.votos) as xvotos_be
from xvotacoes, xfreguesias, xconcelhos, xdistritos
where xdistritos.nome = 'Lisboa' and xdistritos.codigo = xconcelhos.distrito and xconcelhos.codigo = xfreguesias.concelho and xfreguesias.codigo = xvotacoes.freguesia and xvotacoes.partido = 'BE'

-- Ambiente Y
select sum(yvotacoes.votos) as yvotos_be
from yvotacoes, yfreguesias, yconcelhos, ydistritos
where ydistritos.nome = 'Lisboa' and ydistritos.codigo = yconcelhos.distrito and yconcelhos.codigo = yfreguesias.concelho and yfreguesias.codigo = yvotacoes.freguesia and yvotacoes.partido = 'BE'

-- Ambiente Z
select sum(zvotacoes.votos) as zvotos_be
from zvotacoes, zfreguesias, zconcelhos, zdistritos
where zdistritos.nome = 'Lisboa' and zdistritos.codigo = zconcelhos.distrito and zconcelhos.codigo = zfreguesias.concelho and zfreguesias.codigo = zvotacoes.freguesia and zvotacoes.partido = 'BE'