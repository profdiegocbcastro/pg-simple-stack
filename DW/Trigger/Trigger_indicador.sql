CREATE OR REPLACE FUNCTION sync_dim_indicador()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_indicador (id, nome, unidade, acao)
        VALUES (new.id, NEW.nome, NEW.unidade, 'I')
        ON CONFLICT (nome) DO UPDATE
            SET unidade = EXCLUDED.unidade,
                acao = 'U';

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_indicador
        SET nome = NEW.nome,
            unidade = NEW.unidade,
            acao = 'U'
        WHERE nome = OLD.nome;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE dw.dim_indicador
        SET acao = 'D'
        WHERE nome = OLD.nome;

        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_sync_dim_indicador
AFTER INSERT OR UPDATE OR DELETE ON public.indicador
FOR EACH ROW EXECUTE FUNCTION sync_dim_indicador();
