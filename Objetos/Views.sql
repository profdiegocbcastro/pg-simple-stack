CREATE OR REPLACE VIEW vw_estatisticas_anuais AS
SELECT
    e.id AS estatistica_id,
    e.ano,
    c.nome AS cidade,
    r.nome AS regiao,
    i.nome AS indicador,
    e.valor_total,
    COALESCE((
        SELECT SUM(valor)
        FROM estatistica_det ed
        WHERE ed.estatistica_id = e.id
    ), 0) AS soma_meses
FROM estatistica e
JOIN cidade c ON c.id = e.cidade_id
JOIN regiao r ON r.id = c.regiao_id
JOIN indicador i ON i.id = e.indicador_id;
