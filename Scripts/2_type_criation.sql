/**
 * Foi criado um novo tipo de dado dia_semana, para atender o tópico onde
 * é necessário a entidade horario_trabalho ter como atributo o dia da semana;
 */

START TRANSACTION;

CREATE TYPE dia_semana AS ENUM (
	'SEGUNDA-FEIRA',
	'TERCA-FEIRA',
	'QUARTA-FEIRA',
	'QUINTA-FEIRA',
	'SEXTA-FEIRA',
	'SABADO',
	'DOMINGO'
);

COMMIT TRANSACTION;