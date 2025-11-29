CREATE OR REPLACE FUNCTION trg_validar_soma_mensal()
RETURNS TRIGGER AS $$
DECLARE
    soma NUMERIC;
BEGIN
    SELECT SUM(valor)
    INTO soma
    FROM estatistica_det
    WHERE estatistica_id = NEW.estatistica_id;

    IF soma IS NOT NULL AND soma <> (
        SELECT valor_total FROM estatistica WHERE id = NEW.estatistica_id
    ) THEN
        RAISE WARNING 'A soma dos meses (%) difere do valor_total da estatistica (%)',
                        soma,
                        (SELECT valor_total FROM estatistica WHERE id = NEW.estatistica_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
