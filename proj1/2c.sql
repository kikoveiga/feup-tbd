select votacoes.partido, freguesias.nome, votacoes.votos
from votacoes, freguesias
where freguesias.codigo = votacoes.freguesia
order by votacoes.votos desc
fetch first 1 row only