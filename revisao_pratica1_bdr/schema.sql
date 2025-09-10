-- Descrição: Script para criação do banco de dados e tabelas da
--            revisão "rede_games".
-- Questões: 1 e 2

-- Questão 1: Criação do banco de dados

CREATE DATABASE rede_games;


-- Questão 2: Criação das tabelas

-- Tabela de Lojas
CREATE TABLE loja (
    id_loja SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela de Clientes
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100)
);

-- Tabela de Jogos
CREATE TABLE jogo (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    ano_lancamento INT,
    genero VARCHAR(50)
);

-- Tabela de Compras
CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    data_compra DATE NOT NULL,
    id_cliente INT REFERENCES cliente(id_cliente),
    id_loja INT REFERENCES loja(id_loja)
);

-- Tabela Associativa Compra-Jogo (Relação N:M)
CREATE TABLE compra_jogo (
    id_compra INT REFERENCES compra(id_compra),
    id_jogo INT REFERENCES jogo(id_jogo),
    quantidade INT NOT NULL,
    PRIMARY KEY (id_compra, id_jogo) -- Chave primária composta
);