


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
    
--chatGPT, still not confirmed