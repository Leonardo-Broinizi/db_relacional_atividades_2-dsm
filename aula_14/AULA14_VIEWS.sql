-- ===================================================================
-- Arquivo: atualiza_schema_aula14.sql
-- Descrição: Adiciona dados e colunas necessárias para
--            os exercícios da Aula 14 (Views).
-- ===================================================================

-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- 1. Adicionar novos parâmetros ('Temperatura' e 'Turbidez')
INSERT INTO parametro (nome) VALUES
('Temperatura'),
('Turbidez');

-- 2. Adicionar a coluna 'data_hora' na tabela 'series_temporais'
ALTER TABLE series_temporais
ADD COLUMN data_hora TIMESTAMP;

-- 3. Atualizar dados antigos com um data_hora (baseado na data da campanha)
UPDATE series_temporais st
SET data_hora = c.data_coleta
FROM campanha c
WHERE st.id_campanha = c.id_campanha
  AND st.data_hora IS NULL;

-- 4. Inserir novos dados de 'Temperatura' (id=3) e 'Turbidez' (id=4)
-- (Assumindo que os IDs 3 e 4 foram gerados no passo 1)
INSERT INTO series_temporais (id_campanha, id_parametro, valor, id_reservatorio, data_hora) VALUES
(1, 3, 25.5, 1, '2024-01-15 10:00:00'), -- Temp Jaguari
(3, 3, 26.1, 2, '2024-03-10 10:30:00'), -- Temp Paraibuna
(1, 4, 4.8, 1, '2024-01-15 10:05:00'),  -- Turb Jaguari (abaixo de 5)
(3, 4, 6.2, 2, '2024-03-10 10:35:00'),  -- Turb Paraibuna (acima de 5)
(5, 4, 3.1, 3, '2023-12-01 11:00:00');  -- Turb Funil (abaixo de 5)


-- ===================================================================
-- Arquivo: AULA14_VIEWS.sql
-- Descrição: Resolução do "Exercício Individual" da Aula 14 (pág. 32).
-- Pré-requisito: Banco "limnologia_db" atualizado com o script
--                'atualiza_schema_aula14.sql'.
-- ===================================================================

-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- 1. Criar uma view vw_media_temperatura_reservatorio
CREATE VIEW vw_media_temperatura_reservatorio AS
SELECT
    r.nome AS reservatorio,
    AVG(s.valor) AS media_temperatura,
    MIN(s.valor) AS min_temperatura,
    MAX(s.valor) AS max_temperatura
FROM reservatorio r
JOIN series_temporais s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome = 'Temperatura'
GROUP BY r.nome;


-- 2. Criar uma view vw_eventos_reservatorio
CREATE VIEW vw_eventos_reservatorio AS
SELECT
    r.nome AS nome_reservatorio,
    p.nome AS nome_parametro,
    s.valor,
    s.data_hora
FROM reservatorio r
JOIN series_temporais s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
ORDER BY s.data_hora DESC;


-- 3. Criar uma view que mostre apenas reservatórios com média de turbidez acima de 5
CREATE VIEW vw_alta_turbidez AS
SELECT
    r.nome AS reservatorio,
    AVG(s.valor) AS media_turbidez
FROM reservatorio r
JOIN series_temporais s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome = 'Turbidez'
GROUP BY r.nome
HAVING AVG(s.valor) > 5;


-- 4. Consultar as views criadas
SELECT * FROM vw_media_temperatura_reservatorio;
SELECT * FROM vw_eventos_reservatorio;
SELECT * FROM vw_alta_turbidez;


-- 5. Remover uma view (DROP VIEW nome)
DROP VIEW IF EXISTS vw_media_temperatura_reservatorio;

-- (Vamos apagar as outras também para limpar o ambiente)
DROP VIEW IF EXISTS vw_eventos_reservatorio;
DROP VIEW IF EXISTS vw_alta_turbidez;



-- ===================================================================
-- Arquivo: VIEW_PROJETO_ABP.sql
-- Descrição: Criação das Views obrigatórias do projeto ABP (pág. 28-30).
-- Pré-requisito: Banco "limnologia_db" atualizado com o script
--                'atualiza_schema_aula14.sql'.
-- ===================================================================

-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- View 1: Análise de qualidade da água por reservatório
CREATE VIEW vw_analise_agua_reservatorio AS
SELECT
    r.nome AS reservatorio,
    p.nome AS parametro,
    AVG(s.valor) AS media,
    MIN(s.valor) AS minimo,
    MAX(s.valor) AS maximo
FROM reservatorio r
JOIN series_temporais s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
GROUP BY r.nome, p.nome
ORDER BY r.nome, p.nome;


-- View 2: Parâmetros críticos (acima da média + desvio padrão)
CREATE VIEW vw_alerta_parametros AS
SELECT
    r.nome AS reservatorio,
    p.nome AS parametro,
    s.valor,
    s.data_hora
FROM series_temporais s
JOIN reservatorio r ON r.id_reservatorio = s.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE s.valor > (
    -- Subconsulta correlacionada para pegar o limiar (média + 1 desvio padrão)
    -- *daquele* parâmetro específico
    SELECT AVG(s2.valor) + STDDEV(s2.valor)
    FROM series_temporais s2
    WHERE s2.id_parametro = s.id_parametro
);


-- Consultando as views do projeto:
SELECT * FROM vw_analise_agua_reservatorio;
SELECT * FROM vw_alerta_parametros;