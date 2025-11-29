# 🔍 Projeto de Normalização, DW e ETL — Dados de Criminalidade

Este projeto tem como objetivo **normalizar uma base de dados bruta de criminalidade**, garantindo que nenhuma informação seja perdida e, posteriormente, **estruturar um Data Warehouse (DW)** com um processo completo de **ETL (Extract, Transform, Load)**.

Além disso, trata-se de um **projeto simplificado para demonstrar a criação de um ambiente PostgreSQL**, desenvolvido como exemplo didático para o **curso de Banco de Dados II do CEFET-RJ**.

---

## 📌 Fonte dos Dados

Os dados foram obtidos no Kaggle:

🔗 https://www.kaggle.com/search?q=roubo+in%3Adatasets

A base contém indicadores anuais de criminalidade, incluindo:

- Homicídio doloso por 100 mil habitantes
- Furto por 100 mil habitantes
- Roubo por 100 mil habitantes
- Furto e roubo de veículo por 100 mil habitantes
- Indicadores por 100 mil veículos
- Cidade
- Região

Essa estrutura original **não estava normalizada**, reunindo diversos indicadores heterogêneos em uma única tabela.

---

## 🎯 Objetivos do Projeto

O projeto aborda um ciclo completo de engenharia de dados:

### ✔️ 1. Limpeza da Base Bruta
Remoção de linhas inconsistentes, padronização de valores e preparação para normalização.

### ✔️ 2. Normalização
Separação das entidades principais, seguindo as regras de 1FN, 2FN e 3FN.
Entidades criadas:

- **Região**
- **Cidade**
- **Indicador**
- **Estatística (fatos anuais)**

### ✔️ 3. Garantia de Integridade
Criação de chaves primárias, estrangeiras e constraints para assegurar consistência sem perda de dados.

### ✔️ 4. Construção do DW
Modelagem dimensional para análises históricas, seguindo boas práticas como:

- Dimensões
- Tabela fato
- Granularidade anual
- Métricas agregáveis

### ✔️ 5. Desenvolvimento do ETL
Pipeline completo responsável por:

- **Extrair** dados da base normalizada
- **Transformar** e consolidar métricas
- **Carregar** no DW

---

## 🎓 Propósito Educacional

Este repositório foi criado como **exemplo prático** para o curso **Banco de Dados II do CEFET-RJ**, oferecendo uma visão completa do processo de construção de um ambiente PostgreSQL para análises.

Os alunos realizaram:

- Download e compreensão da base real do Kaggle
- **Normalização completa** do banco de dados
- Criação de um **dicionário de dados**
- Modelagem e construção do **DW** para responder perguntas de negócio
- **Indexação** das tabelas para otimização
- Implementação de:
  - **Views**
  - **Triggers**
  - **Functions**
  - **Procedures**
- Desenvolvimento de um **ETL** enviando dados do banco operacional para o DW

## 🚀 Resultado Esperado

O fluxo completo trabalhado no projeto é:

**Base Bruta → Normalização → Banco Relacional → ETL → Data Warehouse → Respostas de Negócio**
