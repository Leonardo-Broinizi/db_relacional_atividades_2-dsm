-- Arquivo: inserts.sql
-- Descrição: Script para inserção de dados iniciais no banco
--            "rede_games".
-- Questões: 3 a 7

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