-- Criação das tabelas conforme o exemplo da aula [cite: 70, 76]
CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    id_curso INT REFERENCES cursos(id_curso)
);

-- Inserindo os cursos
-- CORREÇÃO: Adicionado o curso 'Engenharia' para que a próxima inserção funcione.
INSERT INTO cursos (nome) VALUES 
('Engenharia'), 
('Análise de Sistemas'), 
('Computação'), 
('Matemática');

-- Inserindo os alunos, agora com os cursos correspondentes existindo na tabela
INSERT INTO alunos (nome, idade, id_curso) VALUES 
('João Silva', 22, (SELECT id_curso FROM cursos WHERE nome = 'Engenharia')),
('Maria', 21, (SELECT id_curso FROM cursos WHERE nome = 'Análise de Sistemas')),
('Julia', 25, (SELECT id_curso FROM cursos WHERE nome = 'Computação')),
('Ricardo', 31, (SELECT id_curso FROM cursos WHERE nome = 'Matemática'));

-- Verificando a inserção de todos os alunos
SELECT a.nome, a.idade, c.nome AS nome_curso
FROM alunos a
JOIN cursos c ON a.id_curso = c.id_curso;

-- Comando de DELETE praticado na aula
DELETE FROM alunos WHERE nome = 'Ricardo';