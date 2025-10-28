-- ===================================================================
-- Arquivo: exercicio_subconsultas_aula12.sql
-- Descrição: Resolução da Atividade Prática da Aula 12 (BDR-Aula12-101025.pdf).
--            Uso de subconsultas escalares no SELECT.
-- Pré-requisito: Banco "limnologia_db" criado e populado conforme
--                o script 'setup_limnologia_db.sql'.
-- ===================================================================

-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- Consulta Principal:
-- Para cada reservatório, calcula a média, o mínimo e o máximo do pH
-- usando subconsultas correlacionadas no SELECT.
SELECT
    r.nome AS reservatorio,

    -- Subconsulta 1: Calcula a média do pH para o reservatório atual (r)
    (SELECT AVG(s.valor)
     FROM series_temporais s
     INNER JOIN parametro p ON s.id_parametro = p.id_parametro
     WHERE s.id_reservatorio = r.id_reservatorio
       AND p.nome = 'pH'
    ) AS media_ph,

    -- Subconsulta 2: Calcula o valor mínimo do pH para o reservatório atual (r)
    (SELECT MIN(s.valor)
     FROM series_temporais s
     INNER JOIN parametro p ON s.id_parametro = p.id_parametro
     WHERE s.id_reservatorio = r.id_reservatorio
       AND p.nome = 'pH'
    ) AS ph_minimo,

    -- Subconsulta 3: Calcula o valor máximo do pH para o reservatório atual (r)
    (SELECT MAX(s.valor)
     FROM series_temporais s
     INNER JOIN parametro p ON s.id_parametro = p.id_parametro
     WHERE s.id_reservatorio = r.id_reservatorio
       AND p.nome = 'pH'
    ) AS ph_maximo

-- Tabela externa (principal) da consulta
FROM reservatorio r
ORDER BY r.nome; -- Ordena o resultado final pelo nome do reservatório