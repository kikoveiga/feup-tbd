/* select codigo, nome
from freguesias
where freguesias.concelho = 1103 */

select freguesias.codigo, freguesias.nome
from freguesias, concelhos
where freguesias.concelho = concelhos.codigo and concelhos.nome = 'Azambuja'
