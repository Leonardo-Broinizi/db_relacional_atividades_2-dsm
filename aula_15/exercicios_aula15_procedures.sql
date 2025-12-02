-- ===================================================================
-- Arquivo: exercicios_aula15_procedures.sql
-- Descrição: Resolução da Atividade Prática da Aula 15 (Stored Procedures).
-- Baseado no arquivo de correção da professora, mas adaptado para
-- as tabelas reais do 'limnologia_db' e 'biblioteca'.
-- ===================================================================

-- -------------------------------------------------------------------
-- PARTE A: Contexto BIBLIOTECA
-- (Certifique-se de estar conectado ao banco 'biblioteca')
-- -------------------------------------------------------------------

-- 1) Criar SP para atualizar o autor de um livro
-- Objetivo: Alterar o ID do autor de um livro específico.
CREATE OR REPLACE PROCEDURE sp_atualiza_autor_livro(
    p_id_livro INT,
    p_id_autor INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE livro
    SET id_autor = p_id_autor
    WHERE id_livro = p_id_livro;

    -- Feedback visual (opcional, mas útil em testes manuais)
    RAISE NOTICE 'Livro % atualizado para o autor %', p_id_livro, p_id_autor;
END;
$$;

-- 2) Criar SP para excluir livro pelo id
-- Objetivo: Remover um livro do banco dado seu ID.
CREATE OR REPLACE PROCEDURE sp_excluir_livro(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM livro
    WHERE id_livro = p_id;

    RAISE NOTICE 'Livro % excluído com sucesso', p_id;
END;
$$;


-- -------------------------------------------------------------------
-- PARTE B: Contexto PROJETO ABP (LIMNOLOGIA)
-- (Conecte-se ao banco 'limnologia_db' antes de rodar este bloco)
-- -------------------------------------------------------------------

-- 3) Criar SP para cadastrar reservatório
-- Nota: O script de correção da professora incluía latitude/longitude.
-- Se sua tabela 'reservatorio' tiver apenas 'nome', remova os extras.
-- Vou assumir a estrutura básica: INSERT INTO reservatorio (nome) ...
CREATE OR REPLACE PROCEDURE sp_cadastrar_reservatorio(
    p_nome VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO reservatorio (nome)
    VALUES (p_nome);

    RAISE NOTICE 'Reservatório % cadastrado com sucesso', p_nome;
END;
$$;

-- 4) Criar SP para cadastrar parâmetro ambiental
-- Nota: Adaptado para a tabela 'parametro' (coluna 'nome').
CREATE OR REPLACE PROCEDURE sp_cadastrar_parametro(
    p_nome VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO parametro (nome)
    VALUES (p_nome);

    RAISE NOTICE 'Parâmetro % cadastrado', p_nome;
END;
$$;

-- 5) Criar SP para registrar medição
-- Nota: Adaptado para a tabela 'serie_temporal' (colunas: id_reservatorio, id_parametro, valor, data_hora).
CREATE OR REPLACE PROCEDURE sp_registrar_medicao(
    p_id_reservatorio INT,
    p_id_parametro INT,
    p_valor NUMERIC,
    p_data_hora TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO series_temporais(id_reservatorio, id_parametro, valor, data_hora)
    VALUES (p_id_reservatorio, p_id_parametro, p_valor, p_data_hora);

    RAISE NOTICE 'Medição registrada: Valor % em %', p_valor, p_data_hora;
END;
$$;


-- -------------------------------------------------------------------
-- PARTE C: BÔNUS AVANÇADO (Validação)
-- -------------------------------------------------------------------

-- 6) Criar SP com validação que não permite valor negativo
-- Objetivo: Impedir inserção de dados inválidos usando RAISE EXCEPTION.
CREATE OR REPLACE PROCEDURE sp_validar_e_registrar_medicao(
    p_id_reservatorio INT,
    p_id_parametro INT,
    p_valor NUMERIC,
    p_data_hora TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validação: Se o valor for negativo, aborta a execução
    IF p_valor < 0 THEN
        RAISE EXCEPTION 'Valor inválido! Não é permitido valor negativo (%).', p_valor;
    END IF;

    -- Se passou na validação, insere
    INSERT INTO series_temporais(id_reservatorio, id_parametro, valor, data_hora)
    VALUES (p_id_reservatorio, p_id_parametro, p_valor, p_data_hora);

    RAISE NOTICE 'Medição validada e registrada com sucesso: %', p_valor;
END;
$$;

-- ===================================================================
-- TESTES DE EXECUÇÃO (Exemplos de como chamar as procedures)
-- ===================================================================

-- Teste 1: Cadastrar novo reservatório
-- CALL sp_cadastrar_reservatorio('Represa Billings');

-- Teste 2: Registrar medição válida
-- CALL sp_registrar_medicao(1, 1, 7.5, '2025-11-12 08:00:00');

-- Teste 3: Tentar registrar medição negativa (Deve dar Erro)
-- CALL sp_validar_e_registrar_medicao(1, 1, -5.0, '2025-11-12 08:30:00');