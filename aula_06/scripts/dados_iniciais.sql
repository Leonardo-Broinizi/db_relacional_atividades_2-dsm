-- CREATE DATABASE clima_alerta;

-- Tabela de Estados
CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Tabela de Localização (depende de estado)
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9, 6) NOT NULL,
    longitude NUMERIC(9, 6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

-- Tabela de Eventos (depende de tipo_evento e localizacao)
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Tabela de Relatos (depende de evento e usuario)
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Tabela de Alertas (depende de evento)
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);


-- ===================================================================
-- SEÇÃO 2: CARGA DE DADOS INICIAIS (DML - EXERCÍCIOS AULA 05)
-- ===================================================================

-- Inserindo dados nas tabelas independentes primeiro
INSERT INTO estado (sigla_estado, nome_estado) VALUES
('SP', 'São Paulo'), ('RJ', 'Rio de Janeiro'), ('MG', 'Minas Gerais');

INSERT INTO tipo_evento (nome, descricao) VALUES
('Queimada', 'Incêndio de grandes proporções em áreas de vegetação.'),
('Inundação', 'Acúmulo excessivo de água em uma determinada área.'),
('Deslizamento', 'Movimento de terra ou rochas em encostas.');

INSERT INTO usuario (nome, email, senha_hash) VALUES
('Maria Oliveira', 'maria.oliveira@email.com', 'hash_senha_maria'),
('João Silva', 'joao.silva@email.com', 'hash_senha_joao'),
('Ana Costa', 'ana.costa@email.com', 'hash_senha_ana');

-- Inserindo dados nas tabelas dependentes
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado) VALUES
(-23.305000, -45.965000, 'Jacareí', 'SP'),
(-22.906800, -43.172900, 'Rio de Janeiro', 'RJ'),
(-19.916700, -43.934500, 'Belo Horizonte', 'MG');

INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Queimada na Serra da Mantiqueira', 'Fogo se alastrando próximo a áreas residenciais.', '2025-08-22 14:30:00', 'Ativo', 1, 1),
('Inundação no Centro do Rio', 'Fortes chuvas causam alagamentos em vias principais.', '2025-08-21 10:00:00', 'Em Monitoramento', 2, 2),
('Risco de Deslizamento em Ouro Preto', 'Solo encharcado apresenta risco para moradias.', '2025-08-22 09:15:00', 'Resolvido', 3, 3);


-- ===================================================================
-- SEÇÃO 3: EXERCÍCIOS ADICIONAIS (DML - AULA 06)
-- ===================================================================

[cite_start]-- 1. Inserir pelo menos 2 registros em tabelas dependentes (relato e alerta) [cite: 382]
-- Novo relato da usuária 'Ana Costa' (ID 3) sobre o evento de Queimada (ID 1)
INSERT INTO relato (texto, data_hora, id_evento, id_usuario) VALUES
('O cheiro de fumaça está muito forte no meu bairro.', '2025-08-22 18:00:00', 1, 3);

-- Novo alerta de nível 'Alto' para o evento de Inundação no Rio (ID 2)
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento) VALUES
('Risco de transbordamento do rio. Moradores de áreas de risco devem se preparar.', '2025-08-21 14:00:00', 'Alto', 2);

[cite_start]-- 2. Criar uma consulta que ordene registros [cite: 383]
-- Listar todos os usuários em ordem alfabética pelo nome
SELECT nome, email FROM usuario ORDER BY nome ASC;

[cite_start]-- 3. Criar uma consulta que use ORDER BY + LIMIT [cite: 383]
-- Listar os 2 eventos mais recentes que foram registrados no sistema
SELECT titulo, status, data_hora
FROM evento
ORDER BY data_hora DESC
LIMIT 2;
