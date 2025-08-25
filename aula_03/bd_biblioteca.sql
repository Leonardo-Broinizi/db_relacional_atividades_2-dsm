-- Criação das tabelas para o Sistema de Biblioteca

-- Tabela Autor
CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(100)
);

-- Tabela Livro
CREATE TABLE livro (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_publicacao INT,
    isbn VARCHAR(20) UNIQUE
);

-- Tabela Cliente (ou Leitor)
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefone VARCHAR(20)
);

-- Tabela Emprestimo
-- Um cliente pode ter vários empréstimos (Relacionamento 1:N).
-- Por isso, a chave estrangeira id_cliente fica aqui.
CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    id_cliente INT NOT NULL REFERENCES cliente(id_cliente)
);


-- TABELAS ASSOCIATIVAS PARA RELACIONAMENTOS N:M (Muitos-para-Muitos)

-- Tabela Associativa: livro_autor
-- Resolve o relacionamento N:M entre Livro e Autor.
-- Um livro pode ter vários autores, e um autor pode ter escrito vários livros.
CREATE TABLE livro_autor (
    id_livro INT NOT NULL REFERENCES livro(id_livro),
    id_autor INT NOT NULL REFERENCES autor(id_autor),
    -- Chave primária composta para garantir que a mesma combinação de livro e autor não se repita.
    PRIMARY KEY (id_livro, id_autor)
);

-- Tabela Associativa: emprestimo_livro
-- Resolve o relacionamento N:M entre Empréstimo e Livro.
-- Um empréstimo pode conter vários livros, e um livro pode estar em vários empréstimos (em datas diferentes).
CREATE TABLE emprestimo_livro (
    id_emprestimo INT NOT NULL REFERENCES emprestimo(id_emprestimo),
    id_livro INT NOT NULL REFERENCES livro(id_livro),
    -- Chave primária composta.
    PRIMARY KEY (id_emprestimo, id_livro)
);
