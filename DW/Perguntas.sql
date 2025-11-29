-- Mês mais perigoso em cada cidade
SELECT DISTINCT ON (cidade)
       total_mes, cidade, nome_mes
FROM (
    SELECT
        dc.nome AS cidade,
        dt.nome_mes,
        SUM(fc.valor) AS total_mes
    FROM dw.fato_crime fc
    JOIN dw.dim_cidade dc ON dc.id = fc.cidade_id
    JOIN dw.dim_tempo dt ON dt.id = fc.tempo_id
    GROUP BY dc.nome, dt.nome_mes
) AS x
ORDER BY cidade, total_mes DESC;


-- Mês mais perigoso em cada região
SELECT DISTINCT ON (regiao)
       regiao, indicador, total_valor
FROM (
    SELECT
        dc.regiao_nome AS regiao,
        di.nome AS indicador,
        SUM(fc.valor) AS total_valor
    FROM dw.fato_crime fc
    JOIN dw.dim_cidade dc ON dc.id = fc.cidade_id
    JOIN dw.dim_indicador di ON di.id = fc.indicador_id
    GROUP BY dc.regiao_nome, di.nome
) AS x
ORDER BY regiao, total_valor DESC;


-- Tipo de crime mais comum em cada região
SELECT DISTINCT ON (regiao)
       regiao, indicador, total_valor
FROM (
    SELECT
        dc.regiao_nome AS regiao,
        di.nome AS indicador,
        SUM(fc.valor) AS total_valor
    FROM dw.fato_crime fc
    JOIN dw.dim_cidade dc ON dc.id = fc.cidade_id
    JOIN dw.dim_indicador di ON di.id = fc.indicador_id
    GROUP BY dc.regiao_nome, di.nome
) AS x
ORDER BY regiao, total_valor DESC;
