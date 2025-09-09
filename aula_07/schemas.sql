-- 1) Criação do Bando de Dados
CREATE DATABASE banco_sim;

-- 2) Tipos e tabelas
-- Tipo para categoria de transação
CREATE TYPE transaction_type AS ENUM ('deposit', 'withdrawal', 'transfer');

-- Tabela de clientes
CREATE TABLE clientes (
    cliente_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome               VARCHAR(150)        NOT NULL,
    cpf                VARCHAR(14) UNIQUE  NOT NULL, -- formato '000.000.000-00'
    email              VARCHAR(200),
    telefone           VARCHAR(30),
    data_nascimento    DATE,
    criado_em          TIMESTAMPTZ DEFAULT now()
);

-- Tabela de contas
CREATE TABLE contas (
    conta_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id         BIGINT NOT NULL REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    agencia            VARCHAR(10) NOT NULL,
    numero             VARCHAR(20) NOT NULL,
    tipo_conta         VARCHAR(20) NOT NULL, -- exemplo: 'corrente', 'poupanca'
    saldo              NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    moeda              CHAR(3) DEFAULT 'BRL',
    aberta_em          TIMESTAMPTZ DEFAULT now(),
    UNIQUE (agencia, numero)
);

-- Tabela de transações
CREATE TABLE transacoes (
    transacao_id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    conta_id           BIGINT NOT NULL REFERENCES contas(conta_id) ON DELETE CASCADE,
    tipo               transaction_type NOT NULL,
    valor              NUMERIC(14,2) NOT NULL CHECK (valor > 0),
    data_hora          TIMESTAMPTZ DEFAULT now(),
    descricao          TEXT,
    conta_destino_id   BIGINT NULL, -- usado em transferências (pode referenciar outra conta)
    saldo_posterior    NUMERIC(14,2) NULL, -- opcional: saldo da conta depois da transação (para consistência)
    CHECK ( (tipo = 'transfer' AND conta_destino_id IS NOT NULL) OR (tipo <> 'transfer') )
);

-- Índices úteis
CREATE INDEX idx_transacoes_conta ON transacoes(conta_id);
CREATE INDEX idx_transacoes_tipo ON transacoes(tipo);

-- 3) Inserir dados de exemplo

-- Clientes
INSERT INTO clientes (nome, cpf, email, telefone, data_nascimento)
VALUES
('Ana Silva', '123.456.789-00', 'ana.silva@email.com', '(11) 91234-0001', '1985-04-12'),
('Bruno Costa', '234.567.890-11', 'bruno.costa@email.com', '(11) 91234-0002', '1990-09-30'),
('Carla Souza', '345.678.901-22', 'carla.souza@email.com', '(11) 91234-0003', '1978-02-05'),
('Diego Martins', '456.789.012-33', 'diego.martins@email.com', '(11) 91234-0004', '2000-12-10'),
('Eduarda Rocha', '567.890.123-44', 'eduarda.rocha@email.com', '(11) 91234-0005', '1995-06-25');

-- Contas (alguns clientes com mais de uma conta)
INSERT INTO contas (cliente_id, agencia, numero, tipo_conta, saldo)
VALUES
(1, '0001', '10001-0', 'corrente', 3500.00),   -- Ana
(2, '0001', '10002-8', 'corrente', 1250.50),   -- Bruno
(3, '0002', '20001-5', 'poupanca', 9876.75),   -- Carla
(4, '0003', '30001-2', 'corrente', 50.00),     -- Diego
(5, '0001', '10003-6', 'poupanca', 0.00),      -- Eduarda
(1, '0002', '20002-3', 'poupanca', 500.00);    -- Ana (segunda conta)

-- Transações: alguns depósitos, saques (withdrawal) e transferências.
-- Observação: aqui os valores estão em BRL e as linhas de saldo_posterior refletem o saldo após a transação.
-- Ana - conta_id 1 (corrente)
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior)
VALUES
(1, 'deposit',    2000.00, '2025-08-20 10:15:00-03', 'Depósito inicial', 3500.00),
(1, 'withdrawal', 150.00,  '2025-08-21 09:30:00-03', 'Saque caixa eletrônico', 3350.00),
(1, 'withdrawal', 50.00,   '2025-08-22 12:00:00-03', 'Saque cartão débito', 3300.00);

-- Bruno - conta_id 2
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior)
VALUES
(2, 'deposit',    1000.00, '2025-08-10 08:00:00-03', 'Depósito salário', 1250.50),
(2, 'withdrawal', 100.00,  '2025-08-15 17:45:00-03', 'Saque caixa', 1150.50);

-- Carla - conta_id 3
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior)
VALUES
(3, 'deposit',    5000.00, '2025-07-30 11:20:00-03', 'Transferência recebida', 9876.75),
(3, 'withdrawal', 300.00,  '2025-08-05 14:10:00-03', 'Saque', 9576.75);

-- Diego - conta_id 4 (poucas operações)
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior)
VALUES
(4, 'deposit',     200.00, '2025-08-01 09:00:00-03', 'Depósito inicial', 50.00),
(4, 'withdrawal',  150.00, '2025-08-02 18:30:00-03', 'Saque', -100.00); -- Exemplo de overdraft (se quiser permitir)

-- Eduarda - conta_id 5
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior)
VALUES
(5, 'deposit',     500.00, '2025-06-20 10:10:00-03', 'Depósito', 0.00);

-- Transferência: Ana (conta 1) transfere para a poupança dela (conta 6)
-- Para transferência teremos duas linhas: saída da conta origem e entrada na conta destino.
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, conta_destino_id, saldo_posterior)
VALUES
(1, 'transfer', 300.00, '2025-08-25 15:00:00-03', 'Transferência para poupança', 6, 3000.00),
(6, 'deposit',  300.00, '2025-08-25 15:00:01-03', 'Transferência recebida de conta 1', NULL, 800.00);

-- Observação: se preferir que transferências também apareçam como 'transfer' na conta destino,
-- você pode inserir com tipo='transfer' e conta_destino_id preenchido (a modelagem varia conforme necessidade).

-- 4) Ajustes/consistência (opcional)
-- Caso queira garantir que os saldos das contas batam com os últimos saldo_posterior das transações,
-- pode-se atualizar o campo saldo das contas a partir da última transação (exemplo para manutenção):
-- (exemplo genérico — execute se desejar)
-- UPDATE contas c
-- SET saldo = t.saldo_posterior
-- FROM (
--   SELECT conta_id, saldo_posterior
--   FROM transacoes
--   WHERE (conta_id, data_hora) IN (
--     SELECT conta_id, MAX(data_hora) FROM transacoes GROUP BY conta_id
--   )
-- ) t
-- WHERE c.conta_id = t.conta_id AND t.saldo_posterior IS NOT NULL;

-- 5) Dados adicionais (mais exemplos)
INSERT INTO clientes (nome, cpf, email) VALUES ('Felipe Ramos', '678.901.234-55', 'felipe@email.com');
INSERT INTO contas (cliente_id, agencia, numero, tipo_conta, saldo) VALUES (6, '0004', '40001-7', 'corrente', 250.00);
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao, saldo_posterior) VALUES (7, 'deposit', 250.00, '2025-08-27 10:00:00-03', 'Depósito', 250.00);

-- Fim do script de criação e popolamento.



-- Select para somar o total de clientes cadastrados no banco. 
SELECT COUNT(*) AS total_clientes FROM clientes;

-- Select para calcular o saldo total armazenado no banco.
SELECT SUM(saldo) AS saldo_total FROM contas;

-- Select para calcular a média dos saques feitos.
SELECT AVG(valor) AS media_saques FROM transacoes WHERE tipo = 'withdrawal';



select * from contas;

