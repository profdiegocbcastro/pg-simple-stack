CREATE OR REPLACE PROCEDURE sp_inserir_estatistica_completa(
    indicador_id UUID,
    cidade_id UUID,
    ano_input INT,
    valores_mensais NUMERIC[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    soma NUMERIC := 0;
    estatistica_uuid UUID;
    mes INT;
BEGIN
    IF array_length(valores_mensais, 1) <> 12 THEN
        RAISE EXCEPTION 'O array deve conter 12 valores (1 para cada mês)';
    END IF;

    SELECT SUM(x) INTO soma
    FROM unnest(valores_mensais) AS x;

    INSERT INTO estatistica (indicador_id, cidade_id, ano, valor_total)
    VALUES (indicador_id, cidade_id, ano_input, soma)
    RETURNING id INTO estatistica_uuid;

    FOR mes IN 1..12 LOOP
        INSERT INTO estatistica_det (estatistica_id, mes, valor)
        VALUES (estatistica_uuid, mes, valores_mensais[mes]);
    END LOOP;
END;
$$;
