-- Correções dos Exercícios da Aula 14
-- Banco: limnologia / clima_alerta

---------------------------------------------------------------
-- Exercício 1: Reservatórios com média de temperatura maior
-- que a média global de temperatura
---------------------------------------------------------------
SELECT r.nome AS reservatorio,
       AVG(s.valor) AS media_temperatura
FROM serie_temporal s
JOIN parametro p ON s.id_parametro = p.id_parametro
JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
WHERE p.nome_parametro = 'Temperatura'
GROUP BY r.id_reservatorio, r.nome
HAVING AVG(s.valor) > (
    SELECT AVG(s2.valor)
    FROM serie_temporal s2
    JOIN parametro p2 ON s2.id_parametro = p2.id_parametro
    WHERE p2.nome_parametro = 'Temperatura'
)
ORDER BY media_temperatura DESC;


---------------------------------------------------------------
-- Exercício 2: Top 5 maiores valores de turbidez por reservatório
---------------------------------------------------------------
SELECT nome_reservatorio, id_serie, valor, data_hora, rn
FROM (
    SELECT r.nome AS nome_reservatorio,
           s.id_serie,
           s.valor,
           s.data_hora,
           ROW_NUMBER() OVER (
               PARTITION BY s.id_reservatorio
               ORDER BY s.valor DESC
           ) AS rn
    FROM serie_temporal s
    JOIN parametro p ON s.id_parametro = p.id_parametro
    JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
    WHERE p.nome_parametro = 'Turbidez'
) t
WHERE rn <= 5
ORDER BY nome_reservatorio, rn;


---------------------------------------------------------------
-- Exercício 3: Reservatórios que nunca registraram Condutividade
---------------------------------------------------------------
SELECT r.nome AS reservatorio
FROM reservatorio r
WHERE NOT EXISTS (
    SELECT 1
    FROM serie_temporal s
    JOIN parametro p ON s.id_parametro = p.id_parametro
    WHERE s.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'Condutividade'
)
ORDER BY r.nome;


---------------------------------------------------------------
-- Exercício 4: Parâmetros cuja média > média global
---------------------------------------------------------------
WITH media_por_parametro AS (
    SELECT p.nome_parametro,
           AVG(s.valor) AS media_parametro
    FROM serie_temporal s
    JOIN parametro p ON s.id_parametro = p.id_parametro
    GROUP BY p.nome_parametro
),
media_global AS (
    SELECT AVG(valor) AS media_total
    FROM serie_temporal
)
SELECT mpp.nome_parametro, mpp.media_parametro
FROM media_por_parametro mpp, media_global mg
WHERE mpp.media_parametro > mg.media_total
ORDER BY mpp.media_parametro DESC;


---------------------------------------------------------------
-- Exercício 5: Parâmetro com maior valor por reservatório
-- Versão: um registro por reservatório
---------------------------------------------------------------
SELECT reservatorio, nome_parametro, valor, data_hora
FROM (
    SELECT r.id_reservatorio,
           r.nome AS reservatorio,
           p.nome_parametro,
           s.valor,
           s.data_hora,
           ROW_NUMBER() OVER (
               PARTITION BY r.id_reservatorio
               ORDER BY s.valor DESC
           ) AS rn
    FROM serie_temporal s
    JOIN parametro p ON s.id_parametro = p.id_parametro
    JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
) t
WHERE rn = 1
ORDER BY reservatorio;


-- Versão alternativa: todos empates
SELECT reservatorio, nome_parametro, valor, data_hora
FROM (
    SELECT r.nome AS reservatorio,
           p.nome_parametro,
           s.valor,
           s.data_hora,
           RANK() OVER (
               PARTITION BY r.id_reservatorio
               ORDER BY s.valor DESC
           ) AS rk
    FROM serie_temporal s
    JOIN parametro p ON s.id_parametro = p.id_parametro
    JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
) t
WHERE rk = 1
ORDER BY reservatorio, nome_parametro;
