-- public.crime definição

-- Drop table

-- DROP TABLE public.crime;

CREATE TABLE public.crime (
	ano int4 NULL,
	"Homicídio Doloso por 100 mil habitantes" varchar(50) NULL,
	"Furto por 100 mil habitantes" varchar(50) NULL,
	"Roubo por 100 mil habitantes" varchar(50) NULL,
	"Furto e Roubo de Veículo por 100 mil habitantes" varchar(50) NULL,
	"Furto por 100 mil veículos" varchar(50) NULL,
	"Roubo por 100 mil veículos" varchar(50) NULL,
	"Furto e Roubo de Veículo por 100 mil veículos" varchar(50) NULL,
	cidade varchar(50) NULL,
	regiao varchar(50) NULL
);