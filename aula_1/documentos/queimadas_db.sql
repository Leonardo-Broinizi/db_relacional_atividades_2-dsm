-- Passo 1: Criar o banco de dados chamado queimadas_db
CREATE DATABASE queimadas_db;

-- Conecte-se ao banco de dados queimadas_db antes de executar os próximos comandos.
-- No psql: \c queimadas_db

-- Passo 2: Criar a tabela focos_calor
CREATE TABLE focos_calor (
    id SERIAL PRIMARY KEY,
    estado VARCHAR(50),
    bioma VARCHAR(50),
    data_ocorrencia DATE
);

-- Passo 3: Inserir os três registros solicitados
INSERT INTO focos_calor (estado, bioma, data_ocorrencia) VALUES
('Amazonas', 'Amazônia', '2025-02-01'),
('Mato Grosso', 'Cerrado', '2025-02-03'),
('Pará', 'Amazônia', '2025-02-05');

-- Passo 4: Fazer uma consulta para exibir os dados inseridos
SELECT * FROM focos_calor;


-- Conecte-se ao banco de dados desejado antes de executar os comandos.
-- Ex: \c queimadas_db

[cite_start]-- Tabela 1: cliente [cite: 144]
-- Armazena os dados dos clientes do banco.
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY, -- Adicionei um ID para garantir uma chave única.
    [cite_start]nome_cliente VARCHAR(255), [cite: 145]
    [cite_start]cidade_cliente VARCHAR(255), [cite: 146]
    [cite_start]endereco_cliente VARCHAR(255) [cite: 146]
);

[cite_start]-- Tabela 2: agencia [cite: 152]
-- Armazena informações sobre as agências bancárias.
CREATE TABLE agencia (
    [cite_start]nome_agencia VARCHAR(255) PRIMARY KEY, [cite: 153]
    [cite_start]cidade_agencia VARCHAR(255), [cite: 153]
    [cite_start]depositos DECIMAL(15, 2) [cite: 153]
);

[cite_start]-- Tabela 3: conta [cite: 147]
-- Guarda os dados das contas dos clientes.
CREATE TABLE conta (
    [cite_start]numero_conta INT PRIMARY KEY, [cite: 148]
    [cite_start]nome_agencia VARCHAR(255), [cite: 148]
    [cite_start]saldo DECIMAL(15, 2) [cite: 148]
    -- FOREIGN KEY (nome_agencia) REFERENCES agencia(nome_agencia) -- Chave estrangeira (opcional, mas boa prática).
);

[cite_start]-- Tabela 4: emprestimo [cite: 149]
-- Mantém o registro dos empréstimos realizados.
CREATE TABLE emprestimo (
    [cite_start]numero_emprestimo INT PRIMARY KEY, [cite: 150]
    [cite_start]nome_agencia VARCHAR(255), [cite: 151]
    [cite_start]valor DECIMAL(15, 2) [cite: 151]
    -- FOREIGN KEY (nome_agencia) REFERENCES agencia(nome_agencia) -- Chave estrangeira (opcional, mas boa prática).
);

-- Tabela 5: Tabela adicional para cumprir o requisito de 5 tabelas.
-- Armazena dados dos funcionários do banco.
CREATE TABLE funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    nome_completo VARCHAR(255),
    cargo VARCHAR(100),
    data_admissao DATE,
    nome_agencia VARCHAR(255)
    -- FOREIGN KEY (nome_agencia) REFERENCES agencia(nome_agencia) -- Chave estrangeira (opcional, mas boa prática).
);