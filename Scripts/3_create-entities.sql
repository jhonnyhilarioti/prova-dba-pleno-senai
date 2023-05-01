/**
 * Você é um analista de banco de dados em uma instituição de ensino e foi requisitado para 
 * realizar a modelagem de um sistema de agendamento de horários para um salão de beleza. 
 * Para isso, é necessário criar um banco de dados PostgreSQL chamado "prova" e as seguintes entidades:
 * 
 * *Colaborador: nome, CPF e telefone;
 * *Cliente: nome, CPF e telefone;
 * *Horário de trabalho do colaborador: com dia da semana, horário de início e horário de término;
 * *Serviço: com nome e valor.
 * *Agenda: com data, horário, colaborador, cliente e serviço.
 */

/**
 * Obs: Favor atentar-se, pois os comandos de seleção estão comentados.
 */

/**
 * Segue o comando para a criação do banco de dados prova;
 */

START TRANSACTION;

CREATE DATABASE prova;

COMMIT TRANSACTION;

/**
 * Segue os comandos abaixo para a criação das entidades solicitadadas;
 */

START TRANSACTION;

CREATE TABLE IF NOT EXISTS empresa.colaboradores(
	id_colaborador integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome varchar(100) NOT NULL,
	cpf varchar(14) UNIQUE CHECK (cpf SIMILAR TO '([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}'),
	telefone varchar(50) NOT NULL
);
-------------------------------------------

CREATE TABLE IF NOT EXISTS empresa.clientes(
	id_cliente integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome varchar(100) NOT NULL,
	cpf varchar(14) UNIQUE CHECK (cpf SIMILAR TO '([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}'),
	telefone varchar(50) NOT NULL
);
-------------------------------------------

CREATE TABLE empresa.horario_trabalho(
	id_horario_trabalho integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	dia_semana dia_semana,
	data_trabalho date,
	hora_inicio time,
	hora_fim time,
	colaborador_id integer REFERENCES empresa.colaboradores(id_colaborador)
);
------------------------------------------

CREATE TABLE IF NOT EXISTS empresa.servicos(
	id_servico integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome_servico varchar(100) NOT NULL,
	valor_servico DOUBLE PRECISION, 
	tempo_execucao INTERVAL DEFAULT '30 minutes' NOT NULL
);
------------------------------------------

CREATE TABLE IF NOT EXISTS empresa.agendas(
	id_agenda integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	data_agendada date,
	hora_agendada time,
	colaborador_id integer REFERENCES empresa.colaboradores(id_colaborador),
	cliente_id integer REFERENCES empresa.clientes(id_cliente),
	servico_id integer REFERENCES empresa.servicos(id_servico),
	horario_trabalho_id integer REFERENCES empresa.horario_trabalho(id_horario_trabalho)
);
-----------------------------------------

CREATE TABLE IF NOT EXISTS empresa.feriados (
    id_feriado integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_feriado varchar(100) NOT NULL,
    data_feriado date NOT NULL UNIQUE
);

COMMIT TRANSACTION;
---------------------------------------

/*
SELECT * FROM empresa.colaboradores;
SELECT * FROM empresa.clientes;
SELECT * FROM empresa.horario_trabalho;
SELECT * FROM empresa.servicos;
SELECT * FROM empresa.agendas;
SELECT * FROM empresa.feriados;
*/
