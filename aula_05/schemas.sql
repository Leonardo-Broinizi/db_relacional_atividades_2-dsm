-- Criação do Banco de Dados
CREATE DATABASE clima_alerta;

-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de Estados
CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

-- Tabela de Localização
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9, 6) NOT NULL,
    longitude NUMERIC(9, 6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

-- Tabela de Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Tabela de Telefones do Usuário
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Tabela de Eventos
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Tabela de Relatos
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Tabela de Alertas
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

-- Tabela Auxiliar de Histórico de Eventos (NOVA)
CREATE TABLE historico_evento (
    id_historico SERIAL PRIMARY KEY,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    status_anterior VARCHAR(30),
    status_novo VARCHAR(30),
    data_modificacao TIMESTAMP NOT NULL,
    modificado_por_usuario_id INT REFERENCES usuario(id_usuario) -- Opcional: para saber quem mudou
);

-- Exemplo de consulta para verificar a tabela tipo_evento
SELECT * FROM tipo_evento;



-- PASSO 2: INSERÇÃO DE DADOS (EXERCÍCIO PÁGINA 28)
-- Inserindo dados em tabelas que não dependem de outras primeiro.

-- Inserir 3 Estados
INSERT INTO estado (sigla_estado, nome_estado) VALUES
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais');

-- Inserir 3 Tipos de Evento
INSERT INTO tipo_evento (nome, descricao) VALUES
('Queimada', 'Incêndio de grandes proporções em áreas de vegetação.'),
('Inundação', 'Acúmulo excessivo de água em uma determinada área.'),
('Deslizamento', 'Movimento de terra ou rochas em encostas.');

-- Inserir 3 Usuários
INSERT INTO usuario (nome, email, senha_hash) VALUES
('Maria Oliveira', 'maria.oliveira@email.com', 'hash_senha_maria'),
('João Silva', 'joao.silva@email.com', 'hash_senha_joao'),
('Ana Costa', 'ana.costa@email.com', 'hash_senha_ana');

-- Inserir 3 Localizações (referenciando os estados)
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado) VALUES
(-23.305000, -45.965000, 'Jacareí', 'SP'),
(-22.906800, -43.172900, 'Rio de Janeiro', 'RJ'),
(-19.916700, -43.934500, 'Belo Horizonte', 'MG');

-- Inserir 3 Eventos (referenciando tipo_evento e localizacao)
-- Lembre-se que os IDs (1, 2, 3) correspondem à ordem que inserimos acima.
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Queimada na Serra da Mantiqueira', 'Fogo se alastrando próximo a áreas residenciais.', '2025-08-22 14:30:00', 'Ativo', 1, 1),
('Inundação no Centro do Rio', 'Fortes chuvas causam alagamentos em vias principais.', '2025-08-21 10:00:00', 'Em Monitoramento', 2, 2),
('Risco de Deslizamento em Ouro Preto', 'Solo encharcado apresenta risco para moradias.', '2025-08-22 09:15:00', 'Resolvido', 3, 3);

-- Inserir alguns Relatos (referenciando eventos e usuários)
INSERT INTO relato (texto, data_hora, id_evento, id_usuario) VALUES
('Muita fumaça visível da rodovia!', '2025-08-22 15:00:00', 1, 1),
('A rua principal está completamente alagada.', '2025-08-21 11:30:00', 2, 2);

-- Inserir alguns Alertas (referenciando eventos)
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento) VALUES
('Alerta Crítico: Evacuem a área próxima à serra imediatamente.', '2025-08-22 15:10:00', 'Crítico', 1),
('Alerta Médio: Evitem o centro da cidade devido a alagamentos.', '2025-08-21 10:30:00', 'Médio', 2);

------------------------------------------------------------------------------------

-- PASSO 3: CONSULTAS (EXERCÍCIO PÁGINA 28)

-- 1. Criar consultas simples com SELECT em pelo menos 2 tabelas diferentes.

-- Consulta 1: Listar todos os usuários cadastrados.
SELECT nome, email FROM usuario;

-- Consulta 2: Listar todos os eventos com seus títulos e status.
SELECT titulo, status FROM evento;


-- 2. Criar consultas filtradas com WHERE em pelo menos 2 tabelas diferentes.

-- Consulta 3: Mostrar apenas os eventos que estão com o status 'Ativo'.
SELECT titulo, descricao, data_hora FROM evento
WHERE status = 'Ativo';

-- Consulta 4: Encontrar a localização que fica na cidade de 'Jacareí'.
SELECT * FROM localizacao
WHERE cidade = 'Jacareí';


-- EXTRA: Combinando WHERE e ORDER BY (como no exemplo da página 27)
-- Mostrar todos os eventos que NÃO estão resolvidos, ordenando pelos mais recentes primeiro.
SELECT titulo, status, data_hora FROM evento
WHERE status <> 'Resolvido'
ORDER BY data_hora DESC;
