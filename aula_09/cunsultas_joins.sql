-- ===================================================================
-- Arquivo: consultas_joins.sql
-- Descrição: Resolução da Atividade Prática da Aula 09 (BDR-Aula09.pdf).
-- Pré-requisito: Banco "clima_alerta" criado e populado.
-- ===================================================================

-- Consulta A: Escreva uma query que retorne titulo do evento e nome do tipo_evento (INNER JOIN).
SELECT 
    e.titulo AS evento,
    te.nome AS tipo_evento
FROM evento e
INNER JOIN tipo_evento te ON e.id_tipo_evento = te.id_tipo_evento;


-- Consulta B: Escreva uma query que retorne titulo do evento, cidade e sigla_estado (INNER JOIN evento -> localizacao).
SELECT 
    e.titulo AS evento,
    l.cidade,
    l.sigla_estado
FROM evento e
INNER JOIN localizacao l ON e.id_localizacao = l.id_localizacao;


-- ===================================================================
-- ADIÇÃO DE DADOS PARA TESTAR A CONSULTA C
-- Inserindo dois eventos com 'id_localizacao' nulo (cidade nula).
-- ===================================================================
-- Altera a tabela 'evento' e modifica a coluna 'id_localizacao'
-- para REMOVER a restrição "NOT NULL".
ALTER TABLE evento
ALTER COLUMN id_localizacao DROP NOT NULL;

INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Incêndio Misterioso', 'Fogo reportado, localização exata pendente.', '2025-09-10 10:00:00', 'Ativo', 
 (SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Queimada'), 
 NULL);

INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Alerta de Deslizamento', 'Risco detectado por satélite, local a confirmar.', '2025-09-11 11:00:00', 'Em Monitoramento', 
 (SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Deslizamento'), 
 NULL);
-- ===================================================================


-- Consulta C: Escreva uma query que retorne titulo do evento, tipo_evento, cidade, 
-- incluindo eventos que possam não ter localizacao (usar LEFT JOIN quando necessário). Explique.
SELECT 
    e.titulo AS evento,
    te.nome AS tipo_evento,
    l.cidade,
    l.sigla_estado
FROM evento e
INNER JOIN tipo_evento te ON e.id_tipo_evento = te.id_tipo_evento
LEFT JOIN localizacao l ON e.id_localizacao = l.id_localizacao;

-- Explicação da Consulta C:
-- 1. INNER JOIN (para tipo_evento): Um evento NÃO PODE existir sem um tipo.
-- 2. LEFT JOIN (para localizacao): Garante que, mesmo que um evento tenha 'id_localizacao' NULO
--    (como os que acabamos de inserir), ele ainda aparecerá na lista, com 'cidade' e 'sigla_estado' nulos.


-- Consulta D: Reescreva a Consulta B usando RIGHT JOIN (invertendo a ordem das tabelas)
SELECT 
    e.titulo AS evento,
    l.cidade,
    l.sigla_estado
FROM localizacao l
RIGHT JOIN evento e ON l.id_localizacao = e.id_localizacao;


-- Consulta E: Crie uma query que mostre para cada cidade a quantidade de eventos
SELECT 
    l.cidade,
    COUNT(e.id_evento) AS quantidade_de_eventos
FROM evento e
INNER JOIN localizacao l ON e.id_localizacao = l.id_localizacao
GROUP BY l.cidade
ORDER BY quantidade_de_eventos DESC;