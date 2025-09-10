--Arquivo: consultas.sql
-- Descrição: Script com as consultas solicitadas na revisão.
-- Questões: 8 a 10

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