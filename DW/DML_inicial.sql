-- Inserir indicadores
INSERT INTO dw.dim_indicador (nome, unidade)
SELECT i.nome, i.unidade
FROM public.indicador i
ON CONFLICT (nome) DO NOTHING;

-- Inserir cidades
INSERT INTO dw.dim_cidade (nome, regiao_nome)
SELECT c.nome, r.nome
FROM public.cidade c
JOIN public.regiao r ON r.id = c.regiao_id
ON CONFLICT (nome, regiao_nome) DO NOTHING;

-- Inserir tempo (ano/mes)
INSERT INTO dw.dim_tempo (ano, mes)
SELECT DISTINCT e.ano, ed.mes
FROM public.estatistica e
JOIN public.estatistica_det ed ON ed.estatistica_id = e.id
ON CONFLICT (ano, mes) DO NOTHING;

-- Fato
INSERT INTO dw.fato_crime (cidade_id, tempo_id, indicador_id, valor)
SELECT
    dc.id AS cidade_dw_id,
    dt.id AS tempo_dw_id,
    di.id AS indicador_dw_id,
    COALESCE(ed.valor, e.valor) AS valor_final
FROM public.estatistica e
LEFT JOIN public.estatistica_det ed ON ed.estatistica_id = e.id
JOIN public.cidade c ON c.id = e.cidade_id
JOIN public.regiao r ON r.id = c.regiao_id
JOIN public.indicador i ON i.id = e.indicador_id
JOIN dw.dim_cidade dc
    ON dc.nome = c.nome AND dc.regiao_nome = r.nome
JOIN dw.dim_tempo dt
    ON dt.ano = e.ano AND dt.mes = COALESCE(ed.mes, 1)
JOIN dw.dim_indicador di
    ON di.nome = i.nome
WHERE COALESCE(ed.valor, e.valor) IS NOT NULL
ON CONFLICT (cidade_id, tempo_id, indicador_id) DO NOTHING;