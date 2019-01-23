-- 3. Implementação do projeto no SGBD PostgreSQL 
-- (a) Privilégios e Segurança 
-- (a.i) Criação de 02 usuários – um será o owner do BD; o outro irá ter acesso a alguns objetos 
CREATE ROLE mapaedu WITH SUPERUSER LOGIN PASSWORD 'mapaedu';
CREATE ROLE mpedu WITH LOGIN PASSWORD 'mpedu';

-- (a.ii) Criação do BD e sua associação a um usuário (owner) 
-- CREATE DATABASE mapaedu_db;
ALTER DATABASE mapaedu_db OWNER TO mapaedu;

-- (b) Objetos básicos
-- (b.i) Tabelas e constraints (PK, FK, UNIQUE, campos que podem ter valores nulos, checks de validação) de acordo com projeto. 
SET DATESTYLE TO DMY;

CREATE TABLE IF NOT EXISTS estado (
	sigla CHAR(2) NOT NULL,
	nome VARCHAR(20) NOT NULL,
	
	PRIMARY KEY (sigla),
	CHECK (sigla in ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO'))
);

INSERT INTO estado
    VALUES ('AC', 'Acre'),
		   ('AL', 'Alagoas'),
		   ('AP', 'Amapá'),
		   ('AM', 'Amazonas'),
		   ('BA', 'Bahia'),
		   ('CE', 'Ceará'),
		   ('DF', 'Distrito Federal'),
		   ('ES', 'Espírito Santo'),
		   ('GO', 'Goiás'),
		   ('MA', 'Maranhão'),
		   ('MG', 'Minas Gerais'),
		   ('MS', 'Mato Grosso do Sul'),
		   ('MT', 'Mato Grosso'),
		   ('PA', 'Pará'),
		   ('PB', 'Paraíba'),
		   ('PE', 'Pernambuco'),
		   ('PI', 'Piauí'),
		   ('PR', 'Paraná'),
		   ('RJ', 'Rio de Janeiro'),
		   ('RN', 'Rio Grande do Norte'),
		   ('RO', 'Rondônia'),
		   ('RR', 'Roraima'),
		   ('RS', 'Rio Grande do Sul'),
		   ('SC', 'Santa Catarina'),
	       ('SE', 'Sergipe'),
		   ('SP', 'São Paulo'),
		   ('TO', 'Tocantins');
				 
CREATE TABLE IF NOT EXISTS cidade (
	id SERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	id_uf CHAR(2) NOT NULL,
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_uf) REFERENCES estado (sigla)
);
		   
INSERT INTO cidade
	VALUES (DEFAULT, 'João Pessoa', 'PB'),
	       (DEFAULT, 'Campina Grande', 'PB'),
	       (DEFAULT, 'Cabedelo', 'PB'),
	       (DEFAULT, 'Santa Rita', 'PB'),
	       (DEFAULT, 'Bayeux', 'PB'),
	       (DEFAULT, 'Catolé do Rocha', 'PB'),
	       (DEFAULT, 'Patos', 'PB'),
	       (DEFAULT, 'Sousa', 'PB'),
	       (DEFAULT, 'Bonito de Santa Fé', 'PB'),
	       (DEFAULT, 'Cajazeira', 'PB'),
	       (DEFAULT, 'Guarabira', 'PB'),
	       (DEFAULT, 'Conde', 'PB'),
	       (DEFAULT, 'Alagoa Grande', 'PB'),
	       (DEFAULT, 'Piancó', 'PB'),
	       (DEFAULT, 'Sapé', 'PB'),
	       (DEFAULT, 'Santa Luzia', 'PB'),
	       (DEFAULT, 'Rio Tinto', 'PB'),
	       (DEFAULT, 'Rio de Janeiro', 'RJ'),
	       (DEFAULT, 'São Paulo', 'SP'),
	       (DEFAULT, 'Recife', 'PE'),
	       (DEFAULT, 'Natal', 'RN');		   

CREATE TABLE IF NOT EXISTS tipo (
	id SMALLSERIAL NOT NULL,
	tipo VARCHAR(12) NOT NULL,
	
	PRIMARY KEY (id),
	CHECK (tipo in ('Privada', 'Estadual', 'Municipal'))
);
		   
INSERT INTO tipo
	VALUES (DEFAULT, 'Privada'),
           (DEFAULT, 'Estadual'),
           (DEFAULT, 'Municipal');

CREATE TABLE IF NOT EXISTS escola (
	id SERIAL NOT NULL,
	nome VARCHAR(60) NOT NULL,
	id_tipo SMALLINT NOT NULL,
	id_cidade INT NOT NULL,
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_tipo) REFERENCES tipo(id),
	FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);
		   
INSERT INTO escola
	VALUES (DEFAULT, 'CA COC', 1, 1),
	       (DEFAULT, 'Colégio QI', 1, 1),
	       (DEFAULT, 'GEO Sul', 1, 1),
	       (DEFAULT, 'Motiva Praia', 1, 1),
	       (DEFAULT, 'Marista Pio X', 1, 1),
	       (DEFAULT, 'EEEFM Raul Machado', 2, 1),
	       (DEFAULT, 'EEEFM M. D. Fonseca', 2, 1),
	       (DEFAULT, 'EEEFM Prof. Maria Helena Bronzeado', 2, 1),
	       (DEFAULT, 'EMEF Pontes Pedroza', 3, 1),
	       (DEFAULT, 'EMEF Dona Lindu', 3, 2),
	       (DEFAULT, 'EMEF Riacho Doce', 3, 2),
	       (DEFAULT, 'EEEFM São Patrício', 2, 2),
	       (DEFAULT, 'EEEFM Prof. Paulo Pirassununga', 2, 2),
	       (DEFAULT, 'EMEF Rodolfo Villas Boas', 3, 2),
	       (DEFAULT, 'EMEF João Trigueiro', 3, 7),
	       (DEFAULT, 'EMEF Maria do Rosário', 3, 8),
	       (DEFAULT, 'EEEFM João Gilberto', 2, 11),
	       (DEFAULT, 'EMEF João Villarim', 3, 15),
	       (DEFAULT, 'Colégio Bandeirantes', 1, 17),
	       (DEFAULT, 'EMEF Daiana dos Santos', 3, 20);
		   
CREATE TABLE IF NOT EXISTS usuario (
	id SERIAL NOT NULL,
	nome VARCHAR(48) NOT NULL,
	email VARCHAR(48) UNIQUE NOT NULL,
	sexo CHAR(1) NULL,
	id_cidade INT NOT NULL,
	id_escola INT NULL,
	pontos SMALLINT NULL DEFAULT NULL,
	dt_nasc DATE NOT NULL,
	dt_cadastro TIMESTAMP DEFAULT NOW(),
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_cidade) REFERENCES cidade(id),
	FOREIGN KEY (id_escola) REFERENCES escola(id),
	CHECK (sexo in ('F', 'M'))
);

INSERT INTO usuario
    VALUES (DEFAULT, 'Paulo Ricardo', 'pricardo@gmail.com', 'M', 1, 1, 20, '20/05/2005', DEFAULT),
	       (DEFAULT, 'João Rodrigues de Almeida', 'jra@gmail.com', 'M', 1, 4, 18, '01/03/2008', DEFAULT),
	       (DEFAULT, 'Karla de Souza', 'karlasz@gmail.com', NULL, 1, 2, 25, '24/09/1999', DEFAULT),
	       (DEFAULT, 'Diógenes Batista dos Santos', 'diogenesb@outlook.com', 'M', 2, 10, 2, '07/11/2004', DEFAULT),
	       (DEFAULT, 'Juliano Righetto', 'jrighetto@gmail.com', 'M', 17, 17, DEFAULT, '19/10/2002', DEFAULT),
	       (DEFAULT, 'Francisco Silva', 'fsilva15@gmail.com', 'M', 11, NULL, DEFAULT, '11/09/2001', DEFAULT),
	       (DEFAULT, 'Mariana dos Santos Neves', 'msneves@outlook.com', 'F', 2, 10, 14, '09/11/2006', DEFAULT),
	       (DEFAULT, 'Juliana Battisti', 'julianabattisti@gmail.com', NULL, 1, 4, 20, '18/04/2001', DEFAULT),
	       (DEFAULT, 'Luiza Patrícia dos Santos', 'luizinhap@gmail.com', 'F', 1, 3, 20, '10/04/2001', DEFAULT),
	       (DEFAULT, 'Maria Eduarda Félix de Almeida', 'mduda@gmail.com', 'F', 1, 4, 7, '17/07/2007', DEFAULT),
	       (DEFAULT, 'Patrícia Rouanet', 'patrciart@gmail.com', 'F', 2, 10, 11, '23/06/2002', DEFAULT),
	       (DEFAULT, 'Mary de Souza', 'marysouzajp@gmail.com', 'F', 1, NULL, 18, '10/10/1997', DEFAULT),
	       (DEFAULT, 'João de Souza e Silva', 'joaoss@yahoo.com.br', NULL, 14, NULL, DEFAULT, '18/07/2003', DEFAULT),
	       (DEFAULT, 'Luciano Patrício', 'lucianopatricio@outlook.com', 'M', 17, 17, 14, '21/01/2004', DEFAULT),
	       (DEFAULT, 'Jaqueline Belgrado', 'jaquebel@gmail.com', 'F', 2, 11, 10, '12/07/2002', DEFAULT),
	       (DEFAULT, 'Arcênio Segundo', 'arcenio@gmail.com', 'M', 2, NULL, 9, '11/02/1999', DEFAULT),
	       (DEFAULT, 'Diniz Medeiros', 'dinizmed@gmail.com', 'M', 2, 11, 6, '21/01/2003', DEFAULT),
	       (DEFAULT, 'Diogo Silva', 'dslv@outlook.com', 'M', 1, 6, DEFAULT, '31/08/2000', DEFAULT),
	       (DEFAULT, 'Jackie Santini', 'jackiesantini@gmail.com', 'F', 1, 5, 4, '31/12/1995', DEFAULT),
	       (DEFAULT, 'Rafael Medeiros', 'rafamedeiros@gmail.com', 'M', 1, 6, 7, '20/10/2008', DEFAULT);

CREATE TABLE IF NOT EXISTS disciplina (
	id SMALLSERIAL NOT NULL,
	nome VARCHAR(18) NOT NULL,
	
	PRIMARY KEY (id)
);

INSERT INTO disciplina
	VALUES (DEFAULT, 'Língua Portuguesa'),
	       (DEFAULT, 'Matemática'),
	       (DEFAULT, 'Geografia'),
	       (DEFAULT, 'História'),
	       (DEFAULT, 'Ciências'),
	       (DEFAULT, 'Artes'),
	       (DEFAULT, 'Inglês'),
	       (DEFAULT, 'Empreendedorismo'),
	       (DEFAULT, 'Educação Física');
		   
CREATE TABLE IF NOT EXISTS tema (
    id SMALLSERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	id_disciplina INT NOT NULL,
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_disciplina) REFERENCES disciplina(id)
);
		   
INSERT INTO tema
	VALUES (DEFAULT, 'Verbos', '1'),
	       (DEFAULT, 'Abreviaturas', '1'),
	       (DEFAULT, 'Sujeito', '1'),
	       (DEFAULT, 'Substantivo', '1'),
	       (DEFAULT, 'Adjetivo', '1'),
	       (DEFAULT, 'Multiplicação', '2'),
	       (DEFAULT, 'Adição', '2'),
	       (DEFAULT, 'Subtração', '2'),
	       (DEFAULT, 'Divisão', '2'),
	       (DEFAULT, 'Números Primos', '2'),
	       (DEFAULT, 'Mapa', '3'),
	       (DEFAULT, 'Relevo', '3'),
	       (DEFAULT, 'Histótia do Brasil', '4'),
	       (DEFAULT, 'Coronelismo', '4'),
	       (DEFAULT, 'Efeito Estufa', '5'),
	       (DEFAULT, 'Planetas', '5'),
	       (DEFAULT, 'Verbo To Be', '7'),
	       (DEFAULT, 'Animais', '7'),
	       (DEFAULT, 'Futebol', '8'),
	       (DEFAULT, 'Tecido Muscular', '8');
		   
CREATE TABLE IF NOT EXISTS nivel (
	id SMALLSERIAL NOT NULL,
	nivel VARCHAR(22) NOT NULL,
	pontuacao SMALLINT NOT NULL DEFAULT 1,
	
	PRIMARY KEY(id)
);
		   
INSERT INTO nivel
	VALUES (DEFAULT, 'Super Fácil', DEFAULT),
		   (DEFAULT, 'Fácil', 3),
		   (DEFAULT, 'Médio', 5),
		   (DEFAULT, 'Difícil', 7),
		   (DEFAULT, 'Extremamente Difícil', 10);
		   
CREATE TABLE IF NOT EXISTS questao (
    id BIGSERIAL NOT NULL,
	descricao VARCHAR(256) NOT NULL,
	imagem BYTEA NULL,
	id_nivel SMALLINT NOT NULL,
	id_tema INT NOT NULL,
	
	PRIMARY KEY(id),
	FOREIGN KEY (id_nivel) REFERENCES nivel(id),
	FOREIGN KEY (id_tema) REFERENCES tema(id)
);
		   
INSERT INTO questao
	VALUES (DEFAULT, 'Na frase “Degue Mata. Se a gente bobear, ela volta. É hora de esquentar a briga contra o mosquito.”, a palavra ELA substitui a palavra:', NULL, 1, 3),
           (DEFAULT, 'Qual o tipo da frase: "Como se chama o teu gato?".', NULL, 1, 4),
           (DEFAULT, 'Indique a palavra que tem 5 fonemas:', NULL, 1, 5),
           (DEFAULT, 'Qual a variedade linguística da frase: "Na hora de cumê, nois come; Na hora de bebe, nois bebe".', NULL, 1, 2),
           (DEFAULT, 'A palavra que possui mais letra do que fonema, é:', NULL, 5, 5);

CREATE TABLE IF NOT EXISTS alternativa (
    id BIGSERIAL NOT NULL,
	id_questao INT NOT NULL,
	descricao VARCHAR(50) NOT NULL,
	correta BOOLEAN NOT NULL DEFAULT FALSE,
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_questao) REFERENCES questao(id)
);
		   
INSERT INTO alternativa
	VALUES (DEFAULT, 1, 'Dengue', TRUE),
           (DEFAULT, 1, 'Gente', FALSE),
           (DEFAULT, 1, 'Briga', FALSE),
           (DEFAULT, 1, 'Hora', FALSE),
           (DEFAULT, 1, 'Nenhuma das Alternativas', FALSE),
           (DEFAULT, 2, 'Interrogativa', TRUE),
           (DEFAULT, 2, 'Exclamativa', FALSE),
           (DEFAULT, 2, 'Imperativa', FALSE),
           (DEFAULT, 2, 'Declarativa', FALSE),
           (DEFAULT, 2, 'Nenhuma das Alternativas', FALSE),
           (DEFAULT, 3, 'Ficha', FALSE),
           (DEFAULT, 3, 'Molhado', FALSE),
           (DEFAULT, 3, 'Guerra', FALSE),
           (DEFAULT, 3, 'Fixo', TRUE),
           (DEFAULT, 3, 'Nenhuma das Alternativas', FALSE),
           (DEFAULT, 4, 'Linguagem Formal', FALSE),
           (DEFAULT, 4, 'Linguagem Errada', FALSE),
           (DEFAULT, 4, 'Linguagem Informal', TRUE),
           (DEFAULT, 4, 'Linguagem Animal', FALSE),
           (DEFAULT, 4, 'Nenhuma das Alternativas', FALSE),
           (DEFAULT, 5, 'Caderno', FALSE),
           (DEFAULT, 5, 'Chapéu', TRUE),
           (DEFAULT, 5, 'Flores', FALSE),
           (DEFAULT, 5, 'Livro', FALSE),
           (DEFAULT, 5, 'Nenhuma das Alternativas', FALSE);

CREATE TABLE IF NOT EXISTS resposta (
    id BIGSERIAL NOT NULL,
	id_usuario INT NOT NULL,
	id_questao INT NOT NULL,
	resposta BOOLEAN NOT NULL,
	dt_resposta TIMESTAMP DEFAULT NOW(),
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id),
	FOREIGN KEY (id_questao) REFERENCES questao(id)
);

INSERT INTO resposta
	VALUES (DEFAULT, 1, 1, TRUE, DEFAULT),
           (DEFAULT, 1, 2, TRUE, DEFAULT),
           (DEFAULT, 1, 3, TRUE, DEFAULT),
           (DEFAULT, 1, 4, TRUE, DEFAULT),
           (DEFAULT, 1, 5, TRUE, DEFAULT),
           (DEFAULT, 2, 1, TRUE, DEFAULT),
           (DEFAULT, 2, 2, TRUE, DEFAULT),
           (DEFAULT, 3, 1, TRUE, DEFAULT),
           (DEFAULT, 2, 3, TRUE, DEFAULT),
           (DEFAULT, 2, 4, TRUE, DEFAULT),
           (DEFAULT, 3, 2, FALSE, DEFAULT);
		   
-- (b.ii) 10 consultas variadas de acordo com requisitos da aplicação, ou seja, com justificativa semântica.

-- Consulta 1: Ranking TOP 10
SELECT nome, pontos FROM usuario
	WHERE pontos IS NOT NULL
    ORDER BY pontos DESC
	LIMIT 10;

-- Consulta 2: Temas que pertencem a disciplina Matemática
SELECT t.nome from tema as t
    INNER JOIN disciplina as d ON t.id_disciplina = d.id
		   WHERE d.nome = 'Matemática';

-- Consulta 3: Lista de temas agrupados por disciplina
SELECT d.nome AS disciplina, t.nome AS tema from disciplina AS d
    INNER JOIN tema AS t ON t.id_disciplina = d.id
	GROUP BY d.nome, t.nome
    ORDER BY d.nome;
		   
-- Consulta 4: Quantidade de escolas por estado
SELECT uf.nome, COUNT(*) from escola AS esc
	JOIN cidade AS cid ON esc.id_cidade = cid.id
	JOIN estado AS uf ON cid.id_uf = uf.sigla
	GROUP BY uf.nome;
		   
-- Consulta 5: Usuários sem escola cadastrada
SELECT nome FROM usuario WHERE id_escola IS NULL;
		   
-- Consulta 6: Ranking das questões com mais respostas corretas
SELECT q.descricao, COUNT(id_questao) AS acertos FROM resposta AS r
	JOIN questao AS q ON r.id_questao = q.id
	GROUP BY q.descricao, r.resposta
	HAVING r.resposta = TRUE
	ORDER BY 2 DESC;

-- Consulta 7: Usuário sem pontuação
SELECT nome FROM usuario
	WHERE pontos IS NULL OR pontos = 0;
		   
-- Consulta 8: Usuários sem sexo definido
SELECT nome FROM usuario WHERE sexo IS NULL;
		   
-- Consulta 9: Lista de usuários com mais de 18 anos
SELECT nome, (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dt_nasc)) AS idade 
	FROM usuario 
	WHERE dt_nasc <= CURRENT_DATE - INTERVAL'18 YEARS';
		   
-- Consulta 10: Ranking de Pontos por Escola
SELECT esc.nome, SUM(us.pontos) FROM usuario AS us
	JOIN escola AS esc ON us.id_escola = esc.id
	GROUP BY esc.nome
	ORDER BY 2 DESC;
	   
-- (c) Visões
-- (c.i) 01 visão que permita inserção

-- Visão para exibir as escolas privadas
CREATE OR REPLACE VIEW view_escolas_privadas AS
	SELECT nome AS escola, id_tipo, id_cidade FROM escola
		WHERE id_tipo = 1
		ORDER BY nome ASC
WITH CHECK OPTION;

INSERT INTO view_escolas_privadas (escola, id_tipo, id_cidade)
	VALUES ('Interativo Colégio & Curso', 1, 1),
           ('H.B.E. Cólegio e Curso', 1, 1);

SELECT * FROM view_escolas_privadas;
														
-- (c.ii) 02 visões robustas (por exemplo, com vários joins) com justificativa semântica, de acordo com os requisitos da aplicação. 

-- Lista todas as escolas, por estado e cidade
CREATE OR REPLACE VIEW view_escolas AS
	SELECT uf.nome AS estado, cid.nome AS cidade, esc.nome AS escola, t.tipo FROM escola AS esc
		JOIN tipo AS t ON esc.id_tipo = t.id
		JOIN cidade AS cid ON esc.id_cidade = cid.id
		JOIN estado AS uf ON cid.id_uf = uf.sigla 
	GROUP BY estado, cidade, escola, t.tipo
	ORDER BY estado ASC;

SELECT * FROM view_escolas;

-- Ranking dos usuários, por estado e cidade, que acertaram mais questões
CREATE OR REPLACE VIEW view_ranking AS
	SELECT uf.nome AS estado, cid.nome AS cidade, us.nome AS usuario, us.pontos FROM resposta AS r
		JOIN usuario AS us ON r.id_usuario = us.id
		JOIN cidade AS cid ON us.id_cidade = cid.id
		JOIN estado AS uf ON cid.id_uf = uf.sigla 
	GROUP BY estado, cidade, usuario, usuario, us.pontos, r.resposta
	HAVING r.resposta = TRUE
	ORDER BY pontos DESC;

SELECT * FROM view_ranking;

-- (c.iii) Prover acesso a uma das visões para consulta (para usuário 02).
GRANT SELECT ON view_escolas TO mpedu;
		   
-- (d) Funções
-- (d.i) 01 função que use SUM, MAX, MIN, AVG ou COUNT

-- Usuário com o maior número de pontos
CREATE OR REPLACE FUNCTION func_pontuacao_media ()
	RETURNS NUMERIC
AS $$
	DECLARE 
		media NUMERIC;
	BEGIN
		SELECT ROUND(AVG(pontos), 2) INTO media FROM usuario;
		RETURN media;
	END;
$$ LANGUAGE 'plpgsql';

SELECT func_pontuacao_media();
														
-- (d.ii) 01 função que popule, de forma volumosa, uma das tabelas para testes e justificativa sobre índices.

-- Função para inserir novos usuários
CREATE OR REPLACE FUNCTION func_add_usuario 
	(nome VARCHAR, email VARCHAR, sexo CHAR, cidade INT, escola INT, nasc DATE)
	RETURNS INTEGER
AS $$
	BEGIN
		INSERT INTO usuario
			VALUES (DEFAULT, nome, email, sexo, cidade, escola, DEFAULT, nasc, DEFAULT);
		RETURN 1;
		EXCEPTION
			WHEN unique_violation THEN
				RAISE EXCEPTION 'Email já cadastrado.';
				RETURN -1;
	END;
$$ LANGUAGE 'plpgsql';

SELECT func_add_usuario('Rafael Brito', 'rafb@gmail.com', 'M', 1, 2, '10/04/1999');
SELECT func_add_usuario('Poliana DiCaprio Almeida', 'polidcaprio@gmail.com', 'F', 1, 2, '20/05/2002');
SELECT func_add_usuario('Joana Fonn', 'jfonn@gmail.com', 'F', 1, 1, '17/06/1998');
SELECT func_add_usuario('James Dias', 'jdias@gmail.com', 'M', 1, 1, '15/07/2001');
SELECT func_add_usuario('Gutierrez Almeida', 'gutierrez@gmail.com', 'M', 1, 1, '11/08/2006');
SELECT func_add_usuario('João José da Silva', 'jjsilva@gmail.com', 'M', 1, 1, '09/09/2005');
SELECT func_add_usuario('Denis Djhonathan', 'denisdj@gmail.com', 'M', 1, 2, '08/10/2004');
SELECT func_add_usuario('Rafaella Maria', 'rafamaria@gmail.com', 'F', 1, 1, '07/11/2008');
SELECT func_add_usuario('Geni Carla', 'geni@yahoo.com.br', 'F', 1, 1, '06/12/2007');
SELECT func_add_usuario('Carlos Henrique', 'calhenrique@gmail.com', 'M', 1, 1, '05/01/1999');
SELECT func_add_usuario('Diana Almeida', 'dialmeida@gmail.com', 'F', 1, 2, '04/02/2000');
SELECT func_add_usuario('Juliana Ribeiro', 'juliana.r@gmail.com', 'F', 1, 1, '03/03/2001');
SELECT func_add_usuario('Juliano Souza', 'julianosz@gmail.com', 'M', 2, 11, '02/04/2002');
SELECT func_add_usuario('Judith Safra', 'judith@yahoo.com.br', 'F', 1, 2, '01/05/2009');
SELECT func_add_usuario('Marcos C Lima', 'mcl@yahoo.com.br', 'M', 1, 1, '29/06/2007');
SELECT func_add_usuario('Nicácio Lima', 'nicacio@yahoo.com.br', 'M', 1, 1, '28/07/2008');
SELECT func_add_usuario('Dennys Moreira', 'dennysm@gmail.com', 'M', 1, 1, '27/08/2007');
SELECT func_add_usuario('Denilson Silva', 'denilson@gmail.com', 'M', 1, 2, '26/09/2005');
SELECT func_add_usuario('Luan Carlos', 'luanc@gmail.com', 'M', 1, 1, '25/10/2004');
SELECT func_add_usuario('Paula Diniz', 'pauladiniz@gmail.com', 'F', 1, 1, '24/11/2002');
SELECT func_add_usuario('Rita de Cassia', 'ritadecassia@hotmail.com', 'F', 1, 1, '23/12/2001');
SELECT func_add_usuario('Reinaldo Franco', 'rfranco@gmail.com', 'M', 1, 1, '22/01/2000');
SELECT func_add_usuario('Petrônio Gonçalves', 'pgoncalves@gmail.com', 'M', 1, 1, '21/02/2008');
SELECT func_add_usuario('Giuliano Santos', 'guiluano@gmail.com', 'M', 1, 1, '20/03/2007');
SELECT func_add_usuario('Dante Silva', 'danteslv@gmail.com', 'M', 1, 1, '19/04/2006');
SELECT func_add_usuario('Robson Euller', 'r.euller@gmail.com', 'M', 1, 2, '18/05/2005');
SELECT func_add_usuario('Maria Josefa', 'mjosefa@gmail.com', 'F', 1, 2, '17/06/2004');
SELECT func_add_usuario('Mariana Santana', 'marianasanta@hotmail.com', 'F', 1, 2, '16/07/2003');
SELECT func_add_usuario('Marlene Diniz', 'marlene@hotmail.com', 'F', 1, 1, '15/08/2002');
SELECT func_add_usuario('Glaucia de Souza', 'glaucia@gmail.com', 'F', 1, 1, '14/09/2001');
SELECT func_add_usuario('Túlio Santos', 'tuliocsantos@hotmail.com', 'M', 1, 1, '13/10/2000');
SELECT func_add_usuario('Maria Joaquina', 'mariajoaquina@gmail.com', 'F', 1, 1, '12/11/1999');
SELECT func_add_usuario('Larissa do Socorro', 'lala@gmail.com', 'F', 1, 1, '11/12/1998');
SELECT func_add_usuario('João P Santos', 'jpsantos@gmail.com', 'M', 1, 1, '10/04/1997');
SELECT func_add_usuario('Pedro Santos', 'pedrosantos@gmail.com', 'M', 1, 1, '09/03/2000');
SELECT func_add_usuario('Maria Eduarda Oliveira', 'mariadudaoliv@gmail.com', 'F', 1, 2, '08/02/2001');
SELECT func_add_usuario('Margarida Alves', 'margarida@gmail.com', 'F', 1, 2, '07/01/2002');
SELECT func_add_usuario('Dilma dos Santos', 'dilma@gmail.com', 'F', 1, 2, '06/06/2003');
SELECT func_add_usuario('Janaina Silva', 'janainas@gmail.com', 'F', 1, 2, '05/07/2004');
SELECT func_add_usuario('Denise Carla', 'denisecarla@gmail.com', 'F', 1, 1, '04/08/2005');
SELECT func_add_usuario('Rafael Oliveiras', 'rafaeloliveiras@gmail.com', 'M', 1, 1, '03/09/2006');
SELECT func_add_usuario('Mariana S Rodolfo', 'marianasr@gmail.com', 'F', 1, 1, '02/10/2007');
SELECT func_add_usuario('Jennifer dos Santos', 'jennifer@gmail.com', 'F', 1, 3, '01/11/1999');
SELECT func_add_usuario('Luiz Carlos', 'lc@gmail.com', 'M', 1, 4, '30/12/2000');
SELECT func_add_usuario('Santana do Nascimento', 'santana@gmail.com', 'M', 1, 1, '31/08/2001');
SELECT func_add_usuario('Yuri Souza', 'yuri@hotmail.com', 'M', 1, 1, '29/07/2002');
SELECT func_add_usuario('João Medeiros', 'joaomed@gmail.com', 'M', 1, 2, '28/08/2003');
SELECT func_add_usuario('Rafaela Silva Santos', 'rafaelassantos@gmail.com', 'F', 1, 2, '27/10/2004');
SELECT func_add_usuario('Mirna dos Santos', 'mirna@gmail.com', 'F', 1, 1, '26/11/2005');
SELECT func_add_usuario('Gonçalves Silva', 'gsilva@gmail.com', 'M', 1, 1, '25/02/2006');
														
SELECT * FROM usuario;
														
-- (d.iii) Mais 03 funções com justificativa semântica, dentro dos requisitos da aplicação

-- Função 1: Calcula os pontos do usuário de acordo com as respostas corretas dele e atualiza 
-- a coluna 'pontos' da tabela usuario
CREATE OR REPLACE FUNCTION func_add_pontos ()
	RETURNS TRIGGER
AS $$
	BEGIN
		IF (TG_OP = 'DELETE') THEN
			UPDATE usuario SET pontos = (
				SELECT SUM(n.pontuacao) FROM nivel AS n
				JOIN questao AS q ON q.id_nivel = n.id
				JOIN resposta AS r ON r.id_questao = q.id
				WHERE r.id_usuario = OLD.id_usuario
				GROUP BY n.pontuacao, r.resposta
				HAVING r.resposta = TRUE)
			WHERE id = OLD.id_usuario;
			RETURN OLD;
		ELSIF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
			UPDATE usuario SET pontos = (
				SELECT SUM(n.pontuacao) FROM nivel AS n
				JOIN questao AS q ON q.id_nivel = n.id
				JOIN resposta AS r ON r.id_questao = q.id
				WHERE r.id_usuario = NEW.id_usuario
				GROUP BY n.pontuacao, r.resposta
				HAVING r.resposta = TRUE)
			WHERE id = NEW.id_usuario;
			RETURN NEW;
		END IF;
	END;
$$ LANGUAGE 'plpgsql';

-- Função 2: Função para retornar a idade do usuário pela data de nascimento
CREATE OR REPLACE FUNCTION func_idade (id_usr INTEGER)
	RETURNS INTEGER
AS $$
	DECLARE
		idade INTEGER;
	BEGIN
		IF id_usr < 1 THEN
			RAISE EXCEPTION 'Informe um valor positivo.';
		END IF;
														
		SELECT (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dt_nasc)) AS idade 
		INTO idade FROM usuario WHERE id = id_usr;
		
		RETURN idade;
	END;
$$ LANGUAGE 'plpgsql';

SELECT func_idade (1);
SELECT func_idade (0);

-- Função 3: Retorna o nome do usuário a partir do ID.
CREATE OR REPLACE FUNCTION func_nome_usuario_by_id (id_usr INTEGER)
	RETURNS VARCHAR
AS $$
	DECLARE nome_usr VARCHAR(48);
	BEGIN
		SELECT nome INTO nome_usr FROM usuario
			WHERE id = id_usr;
		IF NOT FOUND THEN
			RETURN 'Usuário não existe';
		END IF;
		RETURN nome_usr;
	END;
$$ LANGUAGE 'plpgsql';

SELECT func_nome_usuario_by_id (1);
														  
-- (d.iv) Prover acesso de execução de uma das funções (para usuário 02)
GRANT EXECUTE ON FUNCTION func_pontuacao_media TO mpedu;

-- (e) Índices
-- (e.i) 03 índices para campos indicados (além dos referentes às PKs) com justificativa. Usar tabela povoada com mais dados para testes e justificativa.
CREATE INDEX idx_pontos ON usuario(pontos);
CREATE INDEX idx_cidade ON usuario(id_cidade);
CREATE INDEX idx_escola ON usuario(id_escola);

-- (f) Triggers
-- (f.i) 03 diferentes triggers com justificativa semântica, de acordo com os requisitos da aplicação

-- Trigger pra atualizar os pontos do usuário a cada questão que ele acertar
CREATE TRIGGER trgr_add_pontos 
	AFTER INSERT ON resposta
	FOR EACH ROW 
		EXECUTE PROCEDURE func_add_pontos();
						  
INSERT INTO resposta 
	VALUES (DEFAULT, 6, 5, TRUE);
				
SELECT id, nome, pontos FROM usuario ORDER BY id, nome ASC;
SELECT * FROM resposta;
														  
-- Trigger para atualizar os pontos do usuário em caso de uma resposta ser deletada da tabela resposta
CREATE TRIGGER trgr_delete_resposta
	AFTER DELETE ON resposta
	FOR EACH ROW
		EXECUTE PROCEDURE func_add_pontos();

SELECT * FROM resposta;
DELETE FROM resposta WHERE id = 10;
SELECT * FROM usuario;

-- Trigger para atualizar os pontos do usuário em caso de uma resposta ser atualizada na tabela resposta
CREATE TRIGGER trgr_update_resposta
	AFTER UPDATE ON resposta
	FOR EACH ROW
		EXECUTE PROCEDURE func_add_pontos();

SELECT * FROM resposta;
UPDATE resposta SET resposta = TRUE WHERE id = 11;
SELECT * FROM usuario;													  

-- (g) Outro(s)
-- (g.i) Identificar 02 exemplos de consultas dentro do contexto da aplicação que possam e devam ser melhoradas. Reescrevê-las. Justificar a reescrita.

-- Consulta 1: Alteração da Consulta 10
-- Justificativa: A consulta precis	ava informar, além do nome, o estado e a cidade da escola, pois há
-- possibilidade de ter duas ou mais escolas com o mesmo nome.								  
SELECT esc.nome AS escola, uf.nome AS estado, cid.nome AS cidade, SUM(us.pontos) AS pontos FROM usuario AS us
	JOIN escola AS esc ON us.id_escola = esc.id
	JOIN cidade AS cid ON esc.id_cidade = cid.id
	JOIN estado AS uf ON cid.id_uf = uf.sigla
	GROUP BY pontos, escola, estado, cidade
	HAVING pontos IS NOT NULL
	ORDER BY pontos DESC;
														  
-- Consulta 2: Alteração da Consulta 5
-- Justificativa: Era necessário informar a localização (estado e cidade) do usuário que estava sem escola cadastrada.
SELECT us.nome AS usuario, uf.nome AS estado, cid.nome AS cidade FROM usuario AS us
	JOIN cidade AS cid ON us.id_cidade = cid.id
	JOIN estado AS uf ON cid.id_uf = uf.sigla
	GROUP BY usuario, estado, cidade, us.id_escola
	HAVING us.id_escola IS NULL
	ORDER BY usuario ASC;
