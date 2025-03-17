select designacao
from partidos
where sigla not in (

    select partidos.sigla
    from partidos, listas, distritos
    where distritos.nome = 'Lisboa' and distritos.codigo = listas.distrito and listas.partido = partidos.sigla
)

