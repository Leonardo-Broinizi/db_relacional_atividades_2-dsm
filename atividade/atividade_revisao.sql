-- Questão 1: Criação do banco de dados
CREATE DATABASE rede_games;

-- \c rede_games; -- Comando para conectar-se ao banco de dados no psql

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
    -- A restrição UNIQUE no e-mail, conforme o diagrama, não está na tabela cliente,
    -- mas sim na tabela 'loja'. Se for um erro no diagrama e o e-mail pertencer ao cliente,
    -- a coluna seria adicionada aqui com a restrição UNIQUE.
    -- email VARCHAR(100) UNIQUE NOT NULL
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

-- Tabela Associativa Compra-Jogo
CREATE TABLE compra_jogo (
    id_compra INT REFERENCES compra(id_compra),
    id_jogo INT REFERENCES jogo(id_jogo),
    quantidade INT NOT NULL,
    PRIMARY KEY (id_compra, id_jogo) -- Chave primária composta
);

-- Questão 3: Inserção de lojas
INSERT INTO loja (nome, cidade, email) VALUES
('Game Mania Jacareí', 'Jacareí', 'contato@gamemaniajac.com'),
('Power Games SJC', 'São José dos Campos', 'vendas@powergamessjc.com'),
('Player One Store', 'São Paulo', 'sac@playerone.com');

-- Questão 4: Inserção de clientes
INSERT INTO cliente (nome, cidade) VALUES
('Ana Clara', 'Jacareí'),
('Bruno César', 'São José dos Campos'),
('Daniel Martins', 'Caçapava');

-- Questão 5: Inserção de jogos
-- Para o Matheus, que gosta de Roblox, Minecraft e EA FC, podemos adicionar jogos similares.
INSERT INTO jogo (titulo, ano_lancamento, genero) VALUES
('EA FC 2025', 2024, 'Esportes'),
('Minecraft Dungeons', 2020, 'Aventura'),
('Stardew Valley', 2016, 'Simulação'),
('Cyberpunk 2077', 2020, 'RPG'),
('Goat Simulator 3', 2022, 'Simulação');

-- Questão 6: Registro de compras
INSERT INTO compra (data_compra, id_cliente, id_loja) VALUES
('2025-08-20', 1, 1), -- Ana Clara comprou na Game Mania Jacareí
('2025-09-01', 2, 3); -- Bruno César comprou na Player One Store

-- Questão 7: Registro de jogos nas compras
-- Compra 1 (id_compra = 1)
INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(1, 1, 1),   -- 1 unidade do EA FC 2025
(1, 5, 1);   -- 1 unidade do Goat Simulator 3

-- Compra 2 (id_compra = 2)
INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(2, 2, 1),   -- 1 unidade de Minecraft Dungeons
(2, 4, 2);   -- 2 unidades de Cyberpunk 2077

-- Questão 8: Consulta simples
-- Liste todos os clientes cadastrados, exibindo id_cliente, nome e cidade.
SELECT id_cliente, nome, cidade FROM cliente;

-- Questão 9: Consulta com filtro
-- Liste todos os jogos lançados após 2020, exibindo titulo e ano_lancamento.
SELECT titulo, ano_lancamento
FROM jogo
WHERE ano_lancamento > 2020;

-- Questão 10: Função de agregação
-- Liste quantos jogos foram comprados no total pela rede (soma das quantidades em compra_jogo).
SELECT SUM(quantidade) AS total_jogos_vendidos
FROM compra_jogo;