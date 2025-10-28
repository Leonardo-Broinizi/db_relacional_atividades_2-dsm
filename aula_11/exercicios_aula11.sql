-- ===================================================================
-- Arquivo: exercicios_aula11.sql
-- Descrição: Resolução da Atividade Prática da Aula 11 (BDR-Aula11.pdf).
-- ===================================================================

-- (Conecte-se ao banco 'biblioteca'. Ex: \c biblioteca)

-- 1. Listar quantos livros cada autor publicou por editora (BD Biblioteca).
-- Retorna o nome do autor, o nome da editora e a contagem de livros.
SELECT 
    a.nome AS autor, 
    e.nome AS editora, 
    COUNT(l.id_livro) AS total_livros
FROM autor a
INNER JOIN livro l ON a.id_autor = l.id_autor
INNER JOIN editora e ON l.id_editora = e.id_editora
GROUP BY a.nome, e.nome
ORDER BY autor, total_livros DESC;


-- 2. Listar a média de páginas dos livros por autor (BD Biblioteca).
-- Retorna o nome do autor e a média de páginas de seus livros.
SELECT 
    a.nome AS autor, 
    AVG(l.num_paginas) AS media_de_paginas
FROM autor a
INNER JOIN livro l ON a.id_autor = l.id_autor
GROUP BY a.nome
ORDER BY media_de_paginas DESC;


-- (Conecte-se ao banco 'limnologia_db'. Ex: \c limnologia_db)

-- 3. Mostrar o total de campanhas por reservatório e instituição (limnologia_db).
-- Retorna o reservatório, a instituição e o número de campanhas que
-- aquela instituição fez naquele reservatório.
SELECT 
    r.nome AS reservatorio, 
    i.nome AS instituicao, 
    COUNT(c.id_campanha) AS total_campanhas
FROM campanha c
INNER JOIN reservatorio r ON c.id_reservatorio = r.id_reservatorio
INNER JOIN instituicao i ON c.id_instituicao = i.id_instituicao
GROUP BY r.nome, i.nome
ORDER BY reservatorio, total_campanhas DESC;


-- 4. Mostrar a média de valores de parâmetros por reservatório (limnologia_db).
-- Retorna o reservatório, o parâmetro medido e a média de valor
-- daquele parâmetro naquele reservatório.
SELECT 
    r.nome AS reservatorio, 
    p.nome AS parametro, 
    AVG(s.valor) AS media_valores
FROM series_temporais s
INNER JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
INNER JOIN parametro p ON s.id_parametro = p.id_parametro
GROUP BY r.nome, p.nome
ORDER BY reservatorio, parametro;


-- 5. Listar as instituições que coletaram em mais de um reservatório (limnologia_db).
-- Retorna as instituições e a contagem de reservatórios *distintos*
-- em que elas coletaram, filtrando apenas as que coletaram em mais de um.
SELECT 
    i.nome AS instituicao, 
    COUNT(DISTINCT c.id_reservatorio) AS total_reservatorios_distintos
FROM instituicao i
INNER JOIN campanha c ON i.id_instituicao = c.id_instituicao
GROUP BY i.nome
HAVING COUNT(DISTINCT c.id_reservatorio) > 1
ORDER BY total_reservatorios_distintos DESC;