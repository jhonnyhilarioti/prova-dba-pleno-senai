/**
 * Para realizar testes adequados nas funções e views, é preciso inserir alguns registros no banco de dados;
 */

/**
 * Segue os comandos abaixo para a isnerção dos registros;
 */

START TRANSACTION;

INSERT INTO empresa.colaboradores(nome,cpf,telefone)
VALUES ('Jhonny','123.456.789-78','(48) 99970-3791'),
	   ('José','111.222.333-87','(48) 99970-3791'),
	   ('Maria','987.654.321-10','(48) 99970-3791');
--------------------------------------------
	
INSERT INTO empresa.clientes(nome,cpf,telefone) 
VALUES ('João1','111.222.333-44','(48) 99970-3791'),
	   ('Marcos','121.222.333-44','(48) 99970-3791'),
	   ('Renam','111.232.333-44','(48) 99970-3791'),
	   ('Carlos','111.222.343-44','(48) 99970-3791');
--------------------------------------------
		  
INSERT INTO empresa.horario_trabalho(dia_semana, data_trabalho, hora_inicio, hora_fim, colaborador_id) 
VALUES ('SEGUNDA-FEIRA', '2023-05-02', '09:00:00', '12:00:00', 1),
       ('TERCA-FEIRA', '2023-05-03', '13:00:00', '18:00:00', 1),
       ('QUARTA-FEIRA', '2023-05-04', '08:00:00', '12:00:00', 3),
       ('QUINTA-FEIRA', '2023-05-05', '14:00:00', '17:00:00', 2),
       ('SEXTA-FEIRA', '2023-05-06', '10:00:00', '16:00:00', 2);
--------------------------------------------
   
INSERT INTO empresa.feriados (nome_feriado, data_feriado)
VALUES ('Carnaval', '2023-02-27'),
	   ('Sexta-feira Santa', '2023-04-14'),
	   ('Dia do Trabalho', '2023-05-01'),
	   ('Corpus Christi', '2023-06-15'),
	   ('Independência do Brasil', '2023-09-07'),
	   ('Nossa Senhora Aparecida', '2023-10-12'),
	   ('Finados', '2023-11-02'),
	   ('Proclamação da República', '2023-11-15'),
	   ('Natal', '2023-12-25');

COMMIT TRANSACTION;
	   