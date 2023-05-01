/**
 * É necessário criar uma view com os horários livres;
 */

/**
 * Segue a criação da view para os horarios disponíveis;
 */
CREATE OR REPLACE VIEW empresa.horarios_disponiveis AS
SELECT ht.colaborador_id,
	   ht.data_trabalho,
	  (ht.hora_fim - ht.hora_inicio) AS duracao,
	  (ht.data_trabalho + ht.hora_inicio) AS horario_inicio,
	  (ht.data_trabalho + ht.hora_fim) AS horario_fim
FROM empresa.horario_trabalho ht LEFT JOIN empresa.agendas a
	ON	ht.id_horario_trabalho = a.horario_trabalho_id WHERE a.id_agenda IS NULL;

SELECT * FROM empresa.horarios_disponiveis;
--------------------------------------------
   
/**
 * É necessário criar uma view com os horários agendados, colaborador, serviço executado e o cliente;
 */

/**
 * Segue a criação da view com os horários agendados, colaborador, serviço executado e o cliente;
 */
CREATE OR REPLACE VIEW empresa.view_agendas AS
SELECT
	a.data_agendada,
	a.hora_agendada,
	c.nome AS nome_do_cliente,
	co.nome AS nome_do_colaborador,
	s.nome_servico AS servico_executado
FROM empresa.agendas a 
	JOIN empresa.clientes c ON a.cliente_id = c.id_cliente
	JOIN empresa.colaboradores co ON a.colaborador_id = co.id_colaborador
	JOIN empresa.servicos s ON a.servico_id = s.id_servico;

SELECT * FROM empresa.view_agendas;
-------------------------------------------

/**
 * É necessário criar uma view com os colaboradores, com o total do dia por serviço;
 */

/**
 * Segue a criação da view com o valor total do dia por serviça;
 */
CREATE OR REPLACE VIEW empresa.total_servicos_colaborador AS
SELECT
	colaboradores.nome AS colaborador,
	DATE_TRUNC('day', agendas.data_agendada) AS dia,
	SUM(servicos.valor_servico) AS total_servicos
FROM
	empresa.agendas JOIN empresa.colaboradores 
	ON colaboradores.id_colaborador = agendas.colaborador_id
JOIN empresa.servicos 
	ON servicos.id_servico = agendas.servico_id
GROUP BY colaboradores.nome,
		 DATE_TRUNC('day', agendas.data_agendada);
   
SELECT * FROM empresa.total_servicos_colaborador;
