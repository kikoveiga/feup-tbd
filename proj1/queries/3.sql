select designacao
from partidos
where sigla not in (

    select partidos.sigla
    from partidos, listas, distritos
    where distritos.nome = 'Lisboa' and distritos.codigo = listas.distrito and listas.partido = partidos.sigla
)

-- Ambiente X
select designacao
from xpartidos
where sigla not in (

    select xpartidos.sigla
    from xpartidos, xlistas, xdistritos
    where xdistritos.nome = 'Lisboa' and xdistritos.codigo = xlistas.distrito and xlistas.partido = xpartidos.sigla
)

-- Ambiente Y
select designacao
from ypartidos
where sigla not in (

    select ypartidos.sigla
    from ypartidos, ylistas, ydistritos
    where ydistritos.nome = 'Lisboa' and ydistritos.codigo = ylistas.distrito and ylistas.partido = ypartidos.sigla
)

-- Ambiente Z
select designacao
from zpartidos
where sigla not in (

    select zpartidos.sigla
    from zpartidos, zlistas, zdistritos
    where zdistritos.nome = 'Lisboa' and zdistritos.codigo = zlistas.distrito and zlistas.partido = zpartidos.sigla
)