-- ===================================================================
-- Arquivo: exercicios_aula10.sql
-- Descrição: Resolução da Atividade Prática da Aula 10 (BDR-Aula10.pdf).
-- ===================================================================

-- ===================================================================
-- Exercícios do "BD Biblioteca"
-- ===================================================================

-- 1. Listar quantos livros cada autor possui (BD Biblioteca).
--    (Esta consulta usa o schema da biblioteca fornecido na aula).
SELECT 
    a.nome AS autor, 
    COUNT(l.id_livro) AS total_livros
FROM autor a
INNER JOIN livro l ON a.id_autor = l.id_autor
GROUP BY a.nome
ORDER BY total_livros DESC;


-- 2. Mostrar a média de páginas dos livros por editora (BD Biblioteca).
--
--    NOTA: O schema do BD Biblioteca (pág. 5) não inclui as tabelas
--    'editora' ou a coluna 'paginas'. A consulta abaixo é uma 
--    solução hipotética, assumindo que essas colunas existiriam.
/*
SELECT 
    ed.nome AS editora,
    AVG(l.paginas) AS media_de_paginas
FROM livro l
INNER JOIN editora ed ON l.id_editora = ed.id_editora
GROUP BY ed.nome;
*/


-- ===================================================================
-- Exercícios do "limnologia_db"
-- ===================================================================
-- NOTA: O schema completo do "limnologia_db" não foi fornecido.
-- As consultas abaixo são baseadas nos exemplos e nomes de tabelas
-- e colunas inferidos do PDF.

-- 3. Listar o total de campanhas por reservatório (limnologia_db).
--    (Esta consulta é baseada no exemplo da página 14).
SELECT 
    r.nome AS reservatorio, 
    COUNT(c.id_campanha) AS total_campanhas
FROM reservatorio r
INNER JOIN campanha c ON r.id_reservatorio = c.id_reservatorio
GROUP BY r.nome
ORDER BY total_campanhas DESC;


-- 4. Mostrar a média de valores de cada parâmetro em séries temporais (limnologia_db).
--    (Consulta hipotética baseada em nomes de tabelas/colunas inferidos).
SELECT 
    p.nome AS parametro,
    AVG(st.valor) AS media_de_valor
FROM series_temporais st
INNER JOIN parametro p ON st.id_parametro = p.id_parametro
GROUP BY p.nome;


-- 5. Exibir apenas as instituições que realizaram mais de 3 campanhas (limnologia_db).
--    (Consulta hipotética usando HAVING).
SELECT 
    i.nome AS instituicao,
    COUNT(c.id_campanha) AS total_campanhas
FROM instituicao i
INNER JOIN campanha c ON i.id_instituicao = c.id_instituicao
GROUP BY i.nome
HAVING COUNT(c.id_campanha) > 3
ORDER BY total_campanhas DESC;