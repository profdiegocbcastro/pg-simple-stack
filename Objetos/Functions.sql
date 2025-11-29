CREATE OR REPLACE FUNCTION fn_ranking_cidades(
    ano_input INT,
    indicador_input UUID
)
RETURNS TABLE (
    cidade TEXT,
    regiao TEXT,
    valor_total NUMERIC,
    posicao INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.nome AS cidade,
        r.nome AS regiao,
        e.valor_total,
        ROW_NUMBER() OVER (ORDER BY e.valor_total DESC) AS posicao
    FROM estatistica e
    JOIN cidade c ON c.id = e.cidade_id
    JOIN regiao r ON r.id = c.regiao_id
    WHERE e.ano = ano_input
      AND e.indicador_id = indicador_input
    ORDER BY e.valor_total DESC;
END;
$$ LANGUAGE plpgsql;
