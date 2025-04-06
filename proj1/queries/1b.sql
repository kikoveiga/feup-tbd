select partidos.sigla, partidos.designacao, listas.mandatos
from partidos, listas, distritos
where distritos.nome = 'Lisboa' and distritos.codigo = listas.distrito and partidos.sigla = listas.partido
order by listas.mandatos desc

-- Ambiente X
select xpartidos.sigla, xpartidos.designacao, xlistas.mandatos
from xpartidos, xlistas, xdistritos
where xdistritos.nome = 'Lisboa' and xdistritos.codigo = xlistas.distrito and xpartidos.sigla = xlistas.partido
order by xlistas.mandatos desc

-- Ambiente Y
select ypartidos.sigla, ypartidos.designacao, ylistas.mandatos
from ypartidos, ylistas, ydistritos
where ydistritos.nome = 'Lisboa' and ydistritos.codigo = ylistas.distrito and ypartidos.sigla = ylistas.partido
order by ylistas.mandatos desc

-- Ambiente Z
select zpartidos.sigla, zpartidos.designacao, zlistas.mandatos
from zpartidos, zlistas, zdistritos
where zdistritos.nome = 'Lisboa' and zdistritos.codigo = zlistas.distrito and zpartidos.sigla = zlistas.partido
order by zlistas.mandatos desc