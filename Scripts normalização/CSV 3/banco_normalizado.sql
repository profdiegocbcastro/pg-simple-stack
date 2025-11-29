-- public.estatistica_det definição

-- Drop table

-- DROP TABLE public.estatistica_det;

CREATE TABLE public.estatistica_det (
	id serial4 NOT NULL,
	estatistica_id int4 NOT NULL,
	mes int2 NOT NULL,
	valor numeric NOT NULL
);


-- public.indicador definição

-- Drop table

-- DROP TABLE public.indicador;

CREATE TABLE public.indicador (
	id serial4 NOT NULL,
	nome varchar(255) NOT NULL,
	unidade varchar(80) NULL,
	CONSTRAINT indicador_pkey PRIMARY KEY (id)
);


-- public.regiao definição

-- Drop table

-- DROP TABLE public.regiao;

CREATE TABLE public.regiao (
	id serial4 NOT NULL,
	nome varchar(100) NOT NULL,
	CONSTRAINT regiao_nome_key UNIQUE (nome),
	CONSTRAINT regiao_pkey PRIMARY KEY (id)
);


-- public.cidade definição

-- Drop table

-- DROP TABLE public.cidade;

CREATE TABLE public.cidade (
	id serial4 NOT NULL,
	nome varchar(150) NOT NULL,
	regiao_id int4 NOT NULL,
	CONSTRAINT cidade_nome_regiao_id_key UNIQUE (nome, regiao_id),
	CONSTRAINT cidade_pkey PRIMARY KEY (id),
	CONSTRAINT cidade_regiao_id_fkey FOREIGN KEY (regiao_id) REFERENCES public.regiao(id)
);


-- public.estatistica definição

-- Drop table

-- DROP TABLE public.estatistica;

CREATE TABLE public.estatistica (
	id serial4 NOT NULL,
	ano int4 NOT NULL,
	cidade_id int4 NOT NULL,
	indicador_id int4 NOT NULL,
	valor numeric NULL,
	CONSTRAINT estatistica_ano_cidade_id_indicador_id_key UNIQUE (ano, cidade_id, indicador_id),
	CONSTRAINT estatistica_pkey PRIMARY KEY (id),
	CONSTRAINT estatistica_cidade_id_fkey FOREIGN KEY (cidade_id) REFERENCES public.cidade(id),
	CONSTRAINT estatistica_indicador_id_fkey FOREIGN KEY (indicador_id) REFERENCES public.indicador(id)
);