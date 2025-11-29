CREATE OR REPLACE FUNCTION sync_dim_tempo()
RETURNS TRIGGER AS $$
DECLARE
    ano INT;
    mes INT;
BEGIN
    ano := COALESCE(NEW.ano, OLD.ano);
    mes := COALESCE(NEW.mes, OLD.mes);

    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_tempo (ano, mes, acao)
        VALUES (ano, mes, 'I')
        ON CONFLICT (ano, mes) DO UPDATE SET acao = 'U';

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_tempo
        SET ano = NEW.ano,
            mes = NEW.mes,
            acao = 'U'
        WHERE ano = OLD.ano AND mes = OLD.mes;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE dw.dim_tempo
        SET acao = 'D'
        WHERE ano = OLD.ano AND mes = OLD.mes;

        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_dim_tempo
AFTER INSERT OR UPDATE OR DELETE ON public.estatistica_det
FOR EACH ROW EXECUTE FUNCTION sync_dim_tempo();
