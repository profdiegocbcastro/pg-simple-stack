
CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.fato_crime CASCADE;
DROP TABLE IF EXISTS dw.dim_cidade CASCADE;
DROP TABLE IF EXISTS dw.dim_tempo CASCADE;
DROP TABLE IF EXISTS dw.dim_indicador CASCADE;

CREATE TYPE acao_tipo AS ENUM ('I','U','D');

CREATE TABLE dw.dim_indicador (
    id serial4 PRIMARY KEY,
    nome varchar(255) NOT NULL,
    unidade varchar(80),
    acao acao_tipo DEFAULT 'I',
    created_at timestamptz DEFAULT now(),
    UNIQUE (nome)
);

CREATE TABLE dw.dim_tempo (
    id serial4 PRIMARY KEY,
    ano int4 NOT NULL,
    mes int4 NOT NULL,
    nome_mes varchar(20) GENERATED ALWAYS AS (
        CASE mes
            WHEN 1 THEN 'Janeiro' WHEN 2 THEN 'Fevereiro' WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril' WHEN 5 THEN 'Maio' WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro' WHEN 11 THEN 'Novembro' WHEN 12 THEN 'Dezembro'
        END
    ) STORED,
    trimestre int4 GENERATED ALWAYS AS (
        CASE
            WHEN mes BETWEEN 1 AND 3 THEN 1
            WHEN mes BETWEEN 4 AND 6 THEN 2
            WHEN mes BETWEEN 7 AND 9 THEN 3
            WHEN mes BETWEEN 10 AND 12 THEN 4
        END
    ) STORED,
    acao acao_tipo DEFAULT 'I',
    created_at timestamptz DEFAULT now(),
    UNIQUE (ano, mes)
);

CREATE TABLE dw.dim_cidade (
    id serial4 PRIMARY KEY,
    nome varchar(150) NOT NULL,
    regiao_nome varchar(150) NOT NULL,
    acao acao_tipo DEFAULT 'I',
    created_at timestamptz DEFAULT now(),
    UNIQUE (nome, regiao_nome)
);

CREATE TABLE dw.fato_crime (
    id serial4 PRIMARY KEY,
    cidade_id int4 NOT NULL,
    tempo_id int4,
    indicador_id int4 NOT NULL,
    valor numeric NOT NULL,
    acao acao_tipo DEFAULT 'I',
    created_at timestamptz DEFAULT now(),
    UNIQUE (cidade_id, tempo_id, indicador_id),
    FOREIGN KEY (cidade_id) REFERENCES dw.dim_cidade(id) ON DELETE CASCADE,
    FOREIGN KEY (tempo_id) REFERENCES dw.dim_tempo(id) ON DELETE CASCADE,
    FOREIGN KEY (indicador_id) REFERENCES dw.dim_indicador(id) ON DELETE CASCADE
);

CREATE INDEX ix_dw_fato_crime_cidade ON dw.fato_crime (cidade_id);
CREATE INDEX ix_dw_fato_crime_tempo ON dw.fato_crime (tempo_id);
CREATE INDEX ix_dw_fato_crime_indicador ON dw.fato_crime (indicador_id);


ALTER TABLE dw.fato_crime
ADD CONSTRAINT uq_fato_crime_cidade_tempo_indicador
UNIQUE (cidade_id, indicador_id);


CREATE TABLE etl_execucao (
    processo VARCHAR(100) PRIMARY KEY,
    ultima_execucao TIMESTAMP
);

INSERT INTO etl_execucao (processo, ultima_execucao)
VALUES ('fato_crime', '2000-01-01');
