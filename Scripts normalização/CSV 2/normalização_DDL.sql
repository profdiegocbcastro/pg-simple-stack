-- deletei os registros que estavam estranhos
DELETE FROM crime where ano IS NULL;

Criei a tabela reião
CREATE TABLE regiao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

-- Cidades por região
CREATE TABLE cidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    regiao_id INT NOT NULL REFERENCES regiao(id),
    UNIQUE (nome, regiao_id)
);

-- Os tipos de roubo/crime
CREATE TABLE indicador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    unidade VARCHAR(80)
);

-- Estatísticas de roubo por ano e cidade
CREATE TABLE estatistica (
    id SERIAL PRIMARY KEY,
    ano INT NOT NULL,
    cidade_id INT NOT NULL REFERENCES cidade(id),
    indicador_id INT NOT NULL REFERENCES indicador(id),
    valor NUMERIC,
    UNIQUE (ano, cidade_id, indicador_id)
);
