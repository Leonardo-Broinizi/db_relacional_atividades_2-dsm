-- Passo 1: Criar o banco de dados clima_alerta [cite: 271]
CREATE DATABASE clima_alerta;


-- Passo 2: Criar todas as tabelas do modelo normalizado [cite: 272]

-- Tabela de Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de Localização
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(10, 7) NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    cidade VARCHAR(150),
    estado CHAR(2)
);

-- Tabela Principal de Eventos
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50),
    id_tipo_evento INT REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT REFERENCES localizacao(id_localizacao)
);

-- Tabela de Relatos dos Usuários
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT,
    data_hora TIMESTAMP WITH TIME ZONE,
    id_evento INT REFERENCES evento(id_evento),
    id_usuario INT REFERENCES usuario(id_usuario)
);

-- Tabela de Alertas Gerados
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP WITH TIME ZONE,
    nivel VARCHAR(50),
    id_evento INT REFERENCES evento(id_evento)
);

-- Passo 3: Criar uma tabela auxiliar útil que não estava no modelo inicial [cite: 273]
-- Escolha: historico_evento, conforme sugerido [cite: 274]
CREATE TABLE historico_evento (
    id_historico SERIAL PRIMARY KEY,
    id_evento INT REFERENCES evento(id_evento),
    status_anterior VARCHAR(50),
    status_novo VARCHAR(50),
    data_modificacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    modificado_por_usuario_id INT REFERENCES usuario(id_usuario) NULL -- Pode ser nulo se a mudança for automática
);