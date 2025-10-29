-- ===================================================================
-- Arquivo: REDE_GAMES_SCHEMA.sql
-- Descrição: Script de criação e população do banco 'rede_games'.
--            Responde às questões 1-6 da Atividade Prática.
-- Fonte: BDR-Prova2-2ºSem25-ScriptBD-ProvaPrática.pdf
-- ===================================================================

-- Questão 1: Criação do banco de dados
-- (Execute este comando separadamente ou crie o banco manualmente)
CREATE DATABASE rede_games;

-- (Conecte-se ao banco 'rede_games' antes de continuar. Ex: \c rede_games)

-- Questão 2: Criação das tabelas
-- Tabela de fabricantes de consoles e acessórios
CREATE TABLE fabricante (
    id_fabricante SERIAL PRIMARY KEY,
    nome_fabricante VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
);

-- Tabela de produtos vendidos na rede de lojas
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    preco NUMERIC(10,2) NOT NULL CHECK (preco > 0),
    id_fabricante INT,
    FOREIGN KEY (id_fabricante) REFERENCES fabricante(id_fabricante)
);

-- Tabela de lojas da rede
CREATE TABLE loja (
    id_loja SERIAL PRIMARY KEY,
    nome_loja VARCHAR(120) NOT NULL,
    cidade VARCHAR(80) NOT NULL
);

-- Tabela de vendas
CREATE TABLE venda (
    id_venda SERIAL PRIMARY KEY, -- Corrigido de "id venda" 
    id_produto INT NOT NULL,
    id_loja INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    data_venda DATE NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    FOREIGN KEY (id_loja) REFERENCES loja (id_loja)
);

-- Questão 3: Inserção de fabricantes
INSERT INTO fabricante (nome_fabricante, pais) VALUES
('Nintendo', 'Japão'),
('Sony', 'Japão'),
('Microsoft', 'Estados Unidos'),
('Razer', 'Estados Unidos'),
('HyperX', 'Estados Unidos'),
('Logitech', 'Suíça'),
('Capcom', 'Japão');

-- Questão 4: Inserção de produtos
INSERT INTO produto (nome, preco, id_fabricante) VALUES
('Nintendo Switch OLED', 2499.90, 1),
('Joy-Con Pair', 499.90, 1),
('PlayStation 5', 4399.00, 2),
('DualSense Controller', 399.90, 2),
('Xbox Series X', 4599.90, 3),
('Xbox Wireless Controller', 349.90, 3),
('Razer Kraken Headset', 499.90, 4),
('HyperX Cloud II Headset', 649.90, 5),
('Logitech G Pro Mouse', 399.90, 6),
('Resident Evil 4 Remake', 299.90, 7),
('Street Fighter 6', 349.90, 7);

-- Questão 5: Inserção de lojas
INSERT INTO loja (nome_loja, cidade) VALUES
('Rede Games SP - Paulista', 'São Paulo'),
('Rede Games RJ - Barra', 'Rio de Janeiro'),
('Rede Games MG - BH Shopping', 'Belo Horizonte'),
('Rede Games PR - Curitiba', 'Curitiba');

-- Questão 6: Inserção de vendas
INSERT INTO venda (id_produto, id_loja, quantidade, data_venda) VALUES
(1, 1, 20, '2025-09-20'),
(2, 1, 35, '2025-09-21'),
(3, 2, 15, '2025-09-22'),
(4, 2, 40, '2025-10-01'),
(5, 3, 10, '2025-10-02'),
(6, 3, 5, '2025-10-02'),
(7, 4, 12, '2025-10-05'),
(8, 4, 18, '2025-10-05'),
(9, 1, 20, '2025-10-06'),
(10, 2, 25, '2025-10-06'),
(11, 3, 30, '2025-10-07');


-- ===================================================================
-- Arquivo: PROVA_PRATICA_2.sql
-- Descrição: Respostas das consultas da Atividade Prática (Questões 7-10).
-- Pré-requisito: Banco "rede_games" criado e populado.
-- ===================================================================

-- (Conecte-se ao banco 'rede_games'. Ex: \c rede_games)

-- Questão 7: JOIN - Relatório de produtos vendidos
-- Exibe: produto, nome da loja, quantidade:
SELECT 
    p.nome AS produto,
    l.nome_loja,
    v.quantidade
FROM venda v
INNER JOIN produto p ON v.id_produto = p.id_produto
INNER JOIN loja l ON v.id_loja = l.id_loja;


-- Questão 8: GROUP BY - Total de produtos vendidos por loja
-- Exibe: nome da loja, total vendido:
SELECT
    l.nome_loja,
    SUM(v.quantidade) AS total_vendido
FROM venda v
INNER JOIN loja l ON v.id_loja = l.id_loja
GROUP BY l.nome_loja
ORDER BY total_vendido DESC;


-- Questão 9: HAVING - Lojas de alto desempenho
-- Mostra somente lojas que venderam acima de 30 unidades somadas
SELECT
    l.nome_loja,
    SUM(v.quantidade) AS total_vendido
FROM venda v
INNER JOIN loja l ON v.id_loja = l.id_loja
GROUP BY l.nome_loja
HAVING SUM(v.quantidade) > 30 -- 
ORDER BY total_vendido DESC;


-- Questão 10: SUBCONSULTA - Fabricantes com produtos vendidos
-- Exibe: apenas nome_fabricante que já tiveram algum produto vendido.
-- Usando EXISTS:
SELECT 
    f.nome_fabricante
FROM fabricante f
WHERE EXISTS (
    SELECT 1
    FROM produto p
    INNER JOIN venda v ON p.id_produto = v.id_produto
    WHERE p.id_fabricante = f.id_fabricante
);

/* -- Alternativa para Questão 10 - Usando IN:
SELECT 
    f.nome_fabricante
FROM fabricante f
WHERE f.id_fabricante IN (
    SELECT DISTINCT p.id_fabricante
    FROM produto p
    INNER JOIN venda v ON p.id_produto = v.id_produto
);
*/