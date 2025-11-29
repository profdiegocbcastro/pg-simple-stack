INSERT INTO regiao (nome)
SELECT DISTINCT Regiao
FROM csv3
ON CONFLICT (nome) DO NOTHING;

INSERT INTO cidade (nome, regiao_id)
SELECT DISTINCT Cidade,
       (SELECT id FROM regiao r WHERE r.nome = em.Regiao)
FROM csv3 em
ON CONFLICT (nome, regiao_id) DO NOTHING;

INSERT INTO indicador (nome)
SELECT DISTINCT Natureza
FROM csv3
ON CONFLICT (nome) DO NOTHING;

INSERT INTO estatistica (cidade_id, indicador_id, ano, valor)
SELECT
  c.id,
  i.id,
  em.Ano,
  COALESCE(em.Total,
     em.Jan + em.Fev + em.Mar + em.Abr + em.Mai + em.Jun +
     em.Jul + em.Ago + em."Set" + em."Out" + em.Nov + em.Dez
  ) AS total
FROM csv3 em
JOIN cidade c ON c.nome = em.Cidade
JOIN indicador i ON i.nome = em.Natureza;

INSERT INTO estatistica_det (estatistica_id, mes, valor)
SELECT
  e.id,
  m.mes,
  CASE m.mes
    WHEN 1 THEN em.Jan
    WHEN 2 THEN em.Fev
    WHEN 3 THEN em.Mar
    WHEN 4 THEN em.Abr
    WHEN 5 THEN em.Mai
    WHEN 6 THEN em.Jun
    WHEN 7 THEN em.Jul
    WHEN 8 THEN em.Ago
    WHEN 9 THEN em.Set
    WHEN 10 THEN em.Out
    WHEN 11 THEN em.Nov
    WHEN 12 THEN em.Dez
  END AS valor
FROM csv3 em
JOIN cidade c ON c.nome = em.Cidade
JOIN indicador i ON i.nome = em.Natureza
JOIN estatistica e
     ON e.cidade_id = c.id
    AND e.indicador_id = i.id
    AND e.ano = em.ano
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) m(mes);
