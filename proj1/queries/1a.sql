select codigo, nome
from freguesias
where freguesias.concelho = 1103

select freguesias.codigo, freguesias.nome
from freguesias, concelhos
where freguesias.concelho = concelhos.codigo and concelhos.nome = 'Azambuja'

-- Ambiente X
select xfreguesias.codigo, xfreguesias.nome
from xfreguesias, xconcelhos
where xfreguesias.concelho = xconcelhos.codigo and xconcelhos.nome = 'Azambuja'

-- Ambiente Y
select yfreguesias.codigo, yfreguesias.nome
from yfreguesias, yconcelhos
where yfreguesias.concelho = yconcelhos.codigo and yconcelhos.nome = 'Azambuja'

-- Ambiente Z
select zfreguesias.codigo, zfreguesias.nome
from zfreguesias, zconcelhos
where zfreguesias.concelho = zconcelhos.codigo and zconcelhos.nome = 'Azambuja'