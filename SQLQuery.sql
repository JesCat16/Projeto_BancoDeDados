CREATE TABLE Departamentos
(
DepartamentoId varchar(20) PRIMARY KEY,
Departamento varchar(30)
);

CREATE TABLE Professores
(
ProfessorId int PRIMARY KEY,
Nome varchar(20),
Sobrenome varchar(20),
DepartamentoId varchar(20),
FOREIGN KEY (DepartamentoId) REFERENCES Departamentos (DepartamentoId)
);

CREATE TABLE ChefeDepartamento
(
ProfessorId int,
FOREIGN KEY (ProfessorId) REFERENCES Professores(ProfessorId),
DepartamentoId varchar(20),
FOREIGN KEY (DepartamentoId) REFERENCES Departamentos (DepartamentoId)
);

CREATE TABLE Cursos
(
CursoId int PRIMARY KEY,
Curso varchar(100),
DepartamentoId varchar(20),
FOREIGN KEY (DepartamentoId) REFERENCES Departamentos (DepartamentoId),
ProfessorId int,
FOREIGN KEY (ProfessorId) REFERENCES Professores(ProfessorId));

CREATE TABLE Diciplina
(
DiciplinaId varchar(20) PRIMARY KEY,
DepartamentoId varchar(20),
FOREIGN KEY (DepartamentoId) REFERENCES Departamentos (DepartamentoId),
Nome_Diciplina varchar(100),
ProfessorId int,
FOREIGN KEY (ProfessorId) REFERENCES Professores(ProfessorId));

CREATE TABLE Matriz_Curricular
(
MatrizId int PRIMARY KEY,
CursoId int,
FOREIGN KEY (CursoId) REFERENCES Cursos(CursoId),
DiciplinaId varchar(20),
FOREIGN KEY (DiciplinaId) REFERENCES Diciplina(DiciplinaId),
Bimestre varchar(20),
Credito int);

CREATE TABLE Historico_Professor
(
HistoricoPId int PRIMARY KEY,
ProfessorId int,
FOREIGN KEY (ProfessorId) REFERENCES Professores(ProfessorId),
MatrizId int,
FOREIGN KEY (MatrizId) REFERENCES Matriz_Curricular(MatrizId),
Ano int);

CREATE TABLE TCCs
(
TCCId int PRIMARY KEY,
ProfessorId int,
FOREIGN KEY (ProfessorId) REFERENCES Professores(ProfessorId),
Titulo varchar(100),
Descricao varchar(500)
);

CREATE TABLE Aluno
(
RA varchar(20) PRIMARY KEY,
Nome varchar(20),
Sobrenome varchar(20),
Data_de_Nacimento date,
RG varchar(15),
Credito int default 0,
CPF varchar(20),
CursoId int,
FOREIGN KEY (CursoId) REFERENCES Cursos(CursoId),
Formado int Default 0,
Bimestre_Formacao varchar(20),
Ano_Formacao int,
TCCId int,
FOREIGN KEY (TCCId) REFERENCES TCCs(TCCId));


CREATE TABLE Historico_Aluno
(
HistoricoAId int PRIMARY KEY,
RA varchar(20),
FOREIGN KEY (RA) REFERENCES Aluno(RA),
MatrizId int,
FOREIGN KEY (MatrizId) REFERENCES Matriz_Curricular(MatrizId),
Ano int,
Nota_Final float,
Credito_adiquirido int default 0
);


create trigger atualizaBimestre on Historico_Aluno
 After Insert 
 As
 Begin
	If exists (Select Nota_Final from Historico_Aluno where Nota_Final > 4.99)
		UPDATE Historico_Aluno Set Credito_adiquirido = 1 where Nota_Final > 4.99;
	ELSE
		UPDATE Historico_Aluno Set Credito_adiquirido = 0 where Nota_Final < 4.99;
	END;

create trigger atualizaAluno on Historico_Aluno
 After Insert, Update
 As
 Begin
Merge Aluno as target
Using (Select Credito_adiquirido,Bimestre, RA, Ano, Nota_Final from Historico_Aluno) as source 
ON(target.RA = source.RA and target.Formado != 1)

When Matched Then
UPDATE
	Set target.Credito = target.Credito + source.Credito_adiquirido, 
	target.Ano = source.Ano,
	target.Bimestre = source.Bimestre;
	END
	GO

create trigger atualizaFormatura on Aluno
 After Update
 As
 Begin
Merge Aluno as target
Using (Select Formado from Aluno) as a
On(target.Credito > 5 AND target.TCCId != NULL)
When Matched Then
UPDATE
	Set target.Formado = 1;
	END
	GO

Select * from Aluno

Insert into
Departamentos(DepartamentoId,Departamento)
Values
('CC','Ci�ncia da Computa��o'),
('EE','Engenharia El�trica'),
('EM','Engenharia Mec�nica'),
('CA','Matem�tica e F�sica');

Insert into
Professores(ProfessorId,Nome,Sobrenome,DepartamentoId)
Values
(12346,'Roberto','Amaro','CC'),
(93662,'Eliane','Silva','CC'),
(85236,'Tais','Jorge','CC'),
(63524,'Cecilia','Nobre','EE'),
(85632,'Carlos','Santana','CA'),
(78956,'Jorge','Carlos','CA'),
(89541,'Marcos','Luiz','EM'),
(85214,'Luiza','Martins','EM'),
(96574,'Tales','Mille','EE');



Insert into
ChefeDepartamento(DepartamentoId,ProfessorId)
Values
('CC',12346),
('EE',63524),
('EM',89541),
('CA',78956)

Insert into
Cursos(CursoId,Curso,DepartamentoId,ProfessorId)
Values
(20,'Ci�ncia da Computa��o','CC',12346),
(52,'Ci�ncia de Dados e Intelig�ncia Artificial','CC',85236),
(65,'Engenharia de Rob�s','EE',96574),
(85,'Engenharia Mec�nica','EM',85214),
(10,'Engenharia El�trica','EE',63524);

Insert into
Diciplina(DiciplinaId,DepartamentoId,Nome_Diciplina,ProfessorId)
Values
('CC-1234','CC','Banco de Dados',93662),
('EE-5681','EE','Instala��es El�tricas Industriais',63524),
('CC-7852','CC','Linguagens Formais e Autonomos',12346),
('CC-7895','CC','Desenvolvimento de Algoritmos',85236),
('EM-7895','EM','Mec�nica Geral',89541),
('EM-7899','EM','Engenharia Mec�nica e os Grandes Desafios Globais',85214),
('EE-7895','EE','Eletr�nica Geral',85236),
('CA-8745','CA','F�sica II',78956),
('CA-0230','CA','Estatistica',85632);


Insert into
Matriz_Curricular(MatrizId,CursoId,DiciplinaId,Credito,Bimestre)
Values
(1,20,'CC-1234',1,'1'),
(2,10,'EE-5681',1,'2'),
(3,65,'CC-7895',1,'1'),
(4,85,'EM-7895',1,'2'),
(5,20,'EE-5681',1,'2'),
(6,85,'CA-8745',1,'2'),
(7,85,'EM-7895',1,'1'),
(8,20,'CC-7852',1,'1'),
(9,10,'EE-5681',1,'1'),
(10,20,'CA-0230',1,'2'),
(11,20,'CC-7895',1,'1');

Insert into
Historico_Professor(HistoricoPId,ProfessorId,MatrizId,Ano)
Values
(1,12346,1,2022),
(2,12346,8,2023),
(3,78956,10,2022),
(4,85236,7,2024);

Insert into 
Aluno(RA,Nome,Sobrenome,CursoId,Data_de_Nacimento,CPF,RG)
Values
('11.223.344-5','Bruno','Almeida',20,'2003-12-02','384.946.892-09','12.345.678-9'),
('22.334.455-6','Sofia','Oliveira',52,'2004-03-27','719.638.451-22','23.456.789-0'),
('33.445.566-7','Gabriel','Santos',20,'2005-11-18','542.801.376-03','34.567.890-1'),
('55.667.788-9','Marina','Cardoso',85,'2002-07-04','987.254.691-55','45.678.901-2'),
('66.778.899-0','Isabela','Rodrigues',20,'2006-05-22','123.456.789-00','56.789.012-3'),
('77.889.900-1','Ana','Costa',10,'2001-12-09','876.543.210-98','67.890.123-4'),
('88.990.011-2','Mateus','Lima',85,'2004-06-14','231.947.608-41','78.901.234-5'),
('22.125.004-9','Lucas','Oliveira',20,'2005-10-25','689.524.137-20','89.012.345-6');

Select * from Historico_Aluno;

Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(1,1,'22.125.004-9',2022,6);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(2,1,'33.445.566-7',2022,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(3,4,'55.667.788-9',2023,5);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(4,7,'55.667.788-9',2024,3);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(5,5,'33.445.566-7',2022,5);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(6,8,'22.125.004-9',2022,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(7,8,'33.445.566-7',2023,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(8,9,'77.889.900-1',2022,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(9,5,'22.125.004-9',2022,10);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(10,1,'66.778.899-0',2024,5);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(11,10,'33.445.566-7',2023,5);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(12,10,'22.125.004-9',2023,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(13,11,'33.445.566-7',2024,5);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(14,11,'22.125.004-9',2024,9);
Insert into 
Historico_Aluno(HistoricoAId,MatrizId,RA,Ano,Nota_Final)
Values
(15,8,'22.125.004-9',2024,9);

Insert into
TCCs(TCCId, ProfessorId,Titulo,Descricao)
Values
(1,12346,'Impacto da Intelig�ncia Artificial na Educa��o Infantil','Impacto da Intelig�ncia Artificial na Educa��o Infantil'),
(2,89541,'An�lise da Sustentabilidade Ambiental em Empresas de Tecnologia','Neste estudo, analisamos as pr�ticas de sustentabilidade ambiental adotadas por empresas de tecnologia, examinando seus impactos no meio ambiente e a efic�cia de suas estrat�gias de mitiga��o.'),
(3,93662,'Tecnologias Emergentes e o Futuro do Trabalho','Neste trabalho, exploramos o impacto das tecnologias emergentes, como intelig�ncia artificial e automa��o, no futuro do trabalho, investigando as mudan�as esperadas no mercado de trabalho e as habilidades necess�rias para se adaptar a essa nova realidade.'),
(4,12346,'Pol�ticas de Inclus�o Digital em Pa�ses em Desenvolvimento','Esta pesquisa analisa as pol�ticas de inclus�o digital adotadas por pa�ses em desenvolvimento, investigando suas iniciativas para promover o acesso � tecnologia e reduzir a divis�o digital dentro de suas sociedades.');

Select * from Aluno

Update Aluno
set TCCId = 1
Where RA = '33.445.566-7' and RA = '22.125.004-9';