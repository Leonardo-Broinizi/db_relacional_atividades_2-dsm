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



INSERT INTO cursos (nome) VALUES ('Análise de Sistemas'), ('Computação'), ('Matemática');

INSERT INTO alunos (nome, idade, id_curso) VALUES ('João Silva', 22, (SELECT id_curso FROM cursos WHERE 	nome='Engenharia'));

SELECT * FROM alunos;

INSERT INTO alunos (nome, idade, id_curso) VALUES
('Maria', 21, (SELECT id_curso FROM cursos WHERE nome='Análise de Sistemas')),
('Julia', 25, (SELECT id_curso FROM cursos WHERE nome='Computação')),
('Ricardo', 31, (SELECT id_curso FROM cursos WHERE nome='Matemática'));


DELETE FROM alunos WHERE id_aluno = 5;


