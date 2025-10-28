-- ===================================================================
-- Arquivo: exercicio_subconsultas_where_aula13.sql
-- Descrição: Resolução da Atividade Prática da Aula 13 (BDR-Aula13-141025.pdf).
--            Uso de subconsultas com IN e EXISTS na cláusula WHERE.
-- Pré-requisito: Banco "limnologia_db" criado e populado conforme
--                o script 'setup_limnologia_db.sql'.
-- ===================================================================

-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- Passo 1: Conferir os parâmetros disponíveis
-- Executado para identificar o nome ou ID do parâmetro desejado.
SELECT * FROM parametro;
-- (Identificamos que o parâmetro é 'Oxigênio Dissolvido')


-- Passo 2: Rodar a subconsulta isolada
-- Mostra a lista de IDs dos reservatórios que possuem medições de 'Oxigênio Dissolvido'.
SELECT DISTINCT s.id_reservatorio -- Usamos DISTINCT para evitar IDs repetidos
FROM series_temporais s
INNER JOIN parametro p ON s.id_parametro = p.id_parametro
WHERE p.nome = 'Oxigênio Dissolvido';
-- Resultado esperado (com base nos dados do setup): 1, 3, 2 (a ordem pode variar)


-- Passo 3: Rodar a query completa com IN
-- Lista os nomes dos reservatórios cujo ID está na lista gerada pela subconsulta.
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE r.id_reservatorio IN (
    SELECT s.id_reservatorio
    FROM series_temporais s
    INNER JOIN parametro p ON s.id_parametro = p.id_parametro
    WHERE p.nome = 'Oxigênio Dissolvido'
);
-- Resultado esperado: Jaguari, Represa Funil (os nomes correspondentes aos IDs 1, 3, 2)


-- Passo 4: Reescrever usando EXISTS
-- Lista os nomes dos reservatórios para os quais existe pelo menos uma medição
-- de 'Oxigênio Dissolvido'. A subconsulta agora é correlacionada.
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE EXISTS (
    SELECT 1 -- Seleciona um valor constante, pois só importa se a linha existe
    FROM series_temporais s
    INNER JOIN parametro p ON s.id_parametro = p.id_parametro
    WHERE s.id_reservatorio = r.id_reservatorio -- Condição de correlação
      AND p.nome = 'Oxigênio Dissolvido'
);
-- Resultado esperado: Jaguari, Represa Funil (o mesmo resultado da consulta com IN)


-- Passo 5: Comparar desempenho (Opcional)
-- Execute as duas consultas anteriores precedidas por EXPLAIN ANALYZE
-- para ver o plano de execução e o tempo gasto pelo PostgreSQL.

-- EXPLAIN ANALYZE
-- SELECT r.nome AS reservatorio
-- FROM reservatorio r
-- WHERE r.id_reservatorio IN (...subconsulta com IN...);

-- EXPLAIN ANALYZE
-- SELECT r.nome AS reservatorio
-- FROM reservatorio r
-- WHERE EXISTS (...subconsulta com EXISTS...);

-- (A análise pode mostrar que EXISTS é potencialmente mais eficiente por parar
--  a busca na subconsulta assim que a primeira correspondência é encontrada).