select sum(votacoes.votos) as votos_be
from votacoes, freguesias, concelhos, distritos
where distritos.nome = 'Lisboa' and distritos.codigo = concelhos.distrito and concelhos.codigo = freguesias.concelho and freguesias.codigo = votacoes.freguesia and votacoes.partido = 'BE'