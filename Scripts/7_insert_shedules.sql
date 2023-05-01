/**
 * É necessário criar uma função para marcar o horário de um cliente para um colaborador, 
 * passando como parâmetro o colaborador, o cliente, o serviço e o horário, 
 * não permitindo mais de um agendamento para o mesmo horário do colaborador e cliente.
 */

/**
 * Segue o comando abaixo para a criação da function de agendamento;
 */
CREATE OR REPLACE FUNCTION empresa.marca_horario(
    colaborador_id INTEGER,
    cliente_id INTEGER,
    servico_id INTEGER,
    data_agendada DATE,
    hora_agendada TIME
) 
RETURNS VOID AS $$
BEGIN
	--verifica se existe um registro na tabela ampres,agendas com o mesmo colaborador, data e hora agendadas,
	--caso exista,lança uma exception com uma mensagen
    IF EXISTS (
        SELECT 1 FROM empresa.agendas a
        WHERE a.colaborador_id = marca_horario.colaborador_id
        AND a.data_agendada = marca_horario.data_agendada
        AND a.hora_agendada = marca_horario.hora_agendada
    ) THEN
        RAISE EXCEPTION 'Horário já agendado para o colaborador';
    END IF;
	--verifica se existe um registro na tabelas emrpesa.agendas, com o mesmo cliente, data e hora agendados,
    --caso exista, lança uma exception.
    IF EXISTS (
        SELECT 1 FROM empresa.agendas a
        WHERE a.cliente_id = marca_horario.cliente_id
        AND a.data_agendada = marca_horario.data_agendada
        AND a.hora_agendada = marca_horario.hora_agendada
    ) THEN
        RAISE EXCEPTION 'Horário já agendado para o cliente';
    END IF;
   --insere umnovo registro na tabela emrpesa.agendas, com os valores passados como parâmetro.
   INSERT INTO empresa.agendas (data_agendada, hora_agendada, colaborador_id, cliente_id, servico_id)
   VALUES (data_agendada, hora_agendada, colaborador_id, cliente_id, servico_id);

END;
$$ LANGUAGE plpgsql;

SELECT empresa.marca_horario(1,1,1,'2023-05-02','09:00:00');
--------------------------------------------------------------

/**
 * É necessário cadastrar no mínimo 3 colaboradores e fazer o lançamento de uma semana de atendimento
 * e uma semana com atendimentos futuros. Deve-se garantir que as funções não permitam lançamentos que conflitem
 * com o funcionário e a agenda dele.
 */

/**
 * Segue os inserts na tabela empresa.agendas utilizando a function empresa.marca_horario;
 */

SELECT empresa.marca_horario(1, 2, 3, '2023-03-06', '10:00:00');
SELECT empresa.marca_horario(1, 3, 2, '2023-03-06', '14:00:00');
SELECT empresa.marca_horario(1, 2, 1, '2023-03-07', '09:00:00');
SELECT empresa.marca_horario(1, 3, 3, '2023-03-07', '13:00:00');
SELECT empresa.marca_horario(1, 1, 2, '2023-03-08', '10:00:00');
SELECT empresa.marca_horario(1, 2, 1, '2023-03-08', '14:00:00');
SELECT empresa.marca_horario(1, 3, 3, '2023-03-09', '09:00:00');
SELECT empresa.marca_horario(1, 2, 2, '2023-03-09', '13:00:00');
SELECT empresa.marca_horario(1, 1, 1, '2023-03-10', '10:00:00');
SELECT empresa.marca_horario(1, 3, 2, '2023-03-10', '14:00:00');

-- Atendimentos Futuros
SELECT empresa.marca_horario(1, 3, 1, '2023-05-22', '09:00:00');
SELECT empresa.marca_horario(1, 2, 3, '2023-05-22', '13:00:00');
SELECT empresa.marca_horario(1, 1, 2, '2023-05-23', '10:00:00');
SELECT empresa.marca_horario(1, 3, 1, '2023-05-23', '14:00:00');
SELECT empresa.marca_horario(1, 2, 3, '2023-05-24', '09:00:00');
SELECT empresa.marca_horario(1, 1, 2, '2023-05-24', '13:00:00');
SELECT empresa.marca_horario(1, 3, 1, '2023-05-25', '10:00:00');
SELECT empresa.marca_horario(1, 2, 2, '2023-05-24', '14:00:00');
SELECT empresa.marca_horario(1, 1, 3, '2023-05-26', '09:00:00');
SELECT empresa.marca_horario(1, 3, 2, '2023-05-26', '13:00:00');

