CREATE OR REPLACE FUNCTION sync_fato_crime()
RETURNS TRIGGER AS $$
DECLARE
    valor_final NUMERIC;
    cidade_dw_id INT;
    tempo_dw_id INT;
    indicador_dw_id INT;
BEGIN
    IF TG_OP = 'DELETE' THEN
        SELECT dc.id, dt.id, di.id
        INTO cidade_dw_id, indicador_dw_id
        FROM public.cidade c
        JOIN public.regiao r ON r.id = c.regiao_id
        JOIN public.indicador i ON i.id = OLD.indicador_id
        JOIN dw.dim_cidade dc
            ON dc.nome = c.nome AND dc.regiao_nome = r.nome
        JOIN dw.dim_indicador di
            ON di.nome = i.nome
        WHERE c.id = OLD.cidade_id;

        UPDATE dw.fato_crime
        SET acao = 'D'
        WHERE cidade_id = cidade_dw_id
          AND tempo_id = tempo_dw_id
          AND indicador_id = indicador_dw_id;

        RETURN OLD;
    END IF;

    -- INSERÇÃO OU UPDATE
    SELECT
        COALESCE(ed.valor, NEW.valor) INTO valor_final
    FROM public.estatistica e
    LEFT JOIN public.estatistica_det ed ON ed.estatistica_id = e.id
    WHERE e.id = NEW.id
    LIMIT 1;

    -- carregar IDs das dimensões
    SELECT dc.id, di.id
    INTO cidade_dw_id, tempo_dw_id, indicador_dw_id
    FROM public.estatistica e
    LEFT JOIN public.estatistica_det ed ON ed.estatistica_id = e.id
    JOIN public.cidade c ON c.id = e.cidade_id
    JOIN public.regiao r ON r.id = c.regiao_id
    JOIN public.indicador i ON i.id = e.indicador_id
    JOIN dw.dim_cidade dc
        ON dc.nome = c.nome AND dc.regiao_nome = r.nome
    JOIN dw.dim_indicador di
        ON di.nome = i.nome
    WHERE e.id = NEW.id;

    SELECT dc.id, di.id
    INTO cidade_dw_id, indicador_dw_id
    FROM public.estatistica e
    JOIN public.cidade c ON c.id = e.cidade_id
    JOIN public.regiao r ON r.id = c.regiao_id
    JOIN public.indicador i ON i.id = e.indicador_id
    JOIN dw.dim_cidade dc
        ON dc.nome = c.nome AND dc.regiao_nome = r.nome
    JOIN dw.dim_indicador di
        ON di.nome = i.nome
    WHERE e.id = new.id;


    INSERT INTO dw.fato_crime (cidade_id, indicador_id, valor, acao)
    VALUES (cidade_dw_id, indicador_dw_id, valor_final, 'I')
    ON CONFLICT (cidade_id, indicador_id)
        DO UPDATE SET valor = EXCLUDED.valor,
                      acao = 'U';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_sync_fato_crime
AFTER INSERT OR UPDATE OR DELETE ON public.estatistica
FOR EACH ROW EXECUTE FUNCTION sync_fato_crime();
