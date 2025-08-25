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
