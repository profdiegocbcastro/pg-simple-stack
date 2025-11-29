-- Inserção de Indicadores
-- Peguei essas info das colunas da tabela original e transformei em linhas para criar o relacionamento correto
INSERT INTO indicador (nome, unidade) VALUES
    ('Homicídio Doloso', 'por 100 mil habitantes'),
    ('Furto', 'por 100 mil habitantes'),
    ('Roubo', 'por 100 mil habitantes'),
    ('Furto e Roubo de Veículo', 'por 100 mil habitantes'),
    ('Furto', 'por 100 mil veículos'),
    ('Roubo', 'por 100 mil veículos'),
    ('Furto e Roubo de Veículo', 'por 100 mil veículos');

-- Tabela de região puxando da tabela crime
INSERT INTO regiao (nome)
SELECT DISTINCT regiao
FROM crime
WHERE regiao IS NOT NULL;

-- Puxando as cidade e relacionando com a região (nova Tabela)
INSERT INTO cidade (nome, regiao_id)
SELECT DISTINCT
    b.cidade,
    r.id AS regiao_id
FROM estatisticas_bruta b
JOIN regiao r
    ON r.nome = b.regiao
WHERE b.cidade IS NOT NULL;

-- Inserindo as estatística de roubo por ano e cidade
INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Homicídio Doloso por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Homicídio Doloso por 100 mil habitantes';

INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Furto por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Furto por 100 mil habitantes';

INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Roubo por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Roubo por 100 mil habitantes';


INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Roubo por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Furto e Roubo de Veículo por 100 mil habitantes';

INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Roubo por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Furto por 100 mil veículos';

INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Roubo por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Roubo por 100 mil veículos';

INSERT INTO estatistica (ano, cidade_id, indicador_id, valor)
SELECT
    CAST(b.ano AS INT),
    c.id,
    i.id,
    NULLIF(REPLACE(b."Roubo por 100 mil habitantes", ',', '.'), '-')::NUMERIC
FROM crime b
JOIN cidade c ON c.nome = b.cidade
JOIN indicador i ON i.nome = 'Furto e Roubo de Veículo por 100 mil veículos';
