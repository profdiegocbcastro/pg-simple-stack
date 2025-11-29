CREATE OR REPLACE FUNCTION sync_dim_cidade()
RETURNS TRIGGER AS $$
DECLARE
    v_regiao_nome TEXT;
    v_regiao_id   INT;
BEGIN
    v_regiao_id := COALESCE(NEW.regiao_id, OLD.regiao_id);

    SELECT nome INTO v_regiao_nome FROM public.regiao WHERE id = v_regiao_id;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_cidade (id, nome, regiao_nome, acao)
        VALUES (NEW.id, NEW.nome, v_regiao_nome, 'I')
        ON CONFLICT (nome, regiao_nome)
            DO UPDATE SET acao = 'U';
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_cidade
        SET nome = NEW.nome,
            regiao_nome = v_regiao_nome,
            acao = 'U'
        WHERE nome = OLD.nome;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE dw.dim_cidade
        SET acao = 'D'
        WHERE nome = OLD.nome;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;