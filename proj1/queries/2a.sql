select sum(votos) as votos_ps
from votacoes
where partido = 'PS'

-- Ambiente X
select sum(votos) as xvotos_ps
from xvotacoes
where partido = 'PS'

-- Ambiente Y
select sum(votos) as yvotos_ps
from yvotacoes
where partido = 'PS'

-- Ambiente Z
select sum(votos) as zvotos_ps
from zvotacoes
where partido = 'PS'