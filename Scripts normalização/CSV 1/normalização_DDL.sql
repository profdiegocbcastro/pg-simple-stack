CREATE TABLE estatistica_det (
    id serial PRIMARY KEY,
    estatistica_id int NOT NULL,
    mes SMALLINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    valor NUMERIC,

    CONSTRAINT fk_estatistica
        FOREIGN KEY (estatistica_id)
        REFERENCES estatistica(id)
        ON DELETE CASCADE
);
