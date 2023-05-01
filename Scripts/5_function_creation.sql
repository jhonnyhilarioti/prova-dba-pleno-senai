/**
 * Cada colaborador deve ter uma carga horária de 8 horas e trabalhar somente em dias uteis;
 */

/**
 * Segue a criação da fuction abaixo, para a verificação das regras de horario de trabalho;
 */
CREATE OR REPLACE FUNCTION empresa.verificar_carga_horaria() 
RETURNS TRIGGER AS $$
DECLARE
    total_horas interval;
BEGIN
    -- calcula a carga horária
    total_horas := NEW.hora_fim - NEW.hora_inicio;
    
    -- verifica se é final de semana
    IF NEW.dia_semana = 'SABADO' OR NEW.dia_semana = 'DOMINGO' THEN
        RAISE EXCEPTION 'Não é permitido trabalhar em finais de semana.';
    END IF;
    
    -- verifica se a carga horária é maior ou igual a 8 horas
    IF total_horas > '8 hours' THEN
        RAISE EXCEPTION 'A carga horária deve ser de até 8 horas diárias.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------

/**
 * Segue a criação da trigger para a restrição de horário e dias na tabela empresa.horario_trabalho;
 */
CREATE TRIGGER verificar_carga_horaria_trigger
    BEFORE INSERT OR UPDATE ON empresa.horario_trabalho
    FOR EACH ROW
    EXECUTE FUNCTION empresa.verificar_carga_horaria();

DROP TRIGGER IF EXISTS verificar_carga_horaria_trigger ON empresa.horario_trabalho;
DROP FUNCTION empresa.verificar_carga_horaria();
------------------------------------------------------
/**
 * É necessário criar uma função para fazer o lançamento da agenda do mês dos colaboradores com horários a cada 30 minutos, 
 * a partir do dia da semana configurado no horário de trabalho, informando o mês de trabalho e o colaborador.
 */

/**
 * !ATENÇÃO!
 * O comando abaixo encontra-se comentado pois sua execução não é valida, 
 * suas informações não foram descartadas para fins didáticos;
 */
/*
CREATE OR REPLACE FUNCTION empresa.lanca_agenda_mensal(
    colaborador_id integer,
    mes_trabalho integer,
    ano_trabalho integer
)
RETURNS void AS $$
DECLARE
    data_inicio date;
    data_fim date;
    dia_semana_trabalho integer;
    data_atual date;
    hora_inicio time;
BEGIN
    -- Encontra a data de início e fim do mês de trabalho
    data_inicio = make_date(ano_trabalho, mes_trabalho, 1);
    data_fim = (make_date(ano_trabalho, mes_trabalho, 1) + INTERVAL '1 MONTH - 1 DAY')::DATE;
    -- Encontra o dia da semana configurado no horário de trabalho do colaborador
    SELECT dia_semana_trabalho INTO dia_semana_trabalho FROM empresa.colaboradores WHERE id_colaborador = colaborador_id;
    -- Inicia a iteração pelas datas do mês de trabalho
    data_atual = data_inicio;
    WHILE data_atual <= data_fim LOOP
        -- Verifica se a data atual é um dia da semana em que o colaborador trabalha
        IF EXTRACT(DOW FROM data_atual) = dia_semana_trabalho THEN
            -- Inicia a iteração pelos horários de trabalho do colaborador
            hora_inicio = (SELECT hora_inicio FROM empresa.colaboradores WHERE id_colaborador = colaborador_id);
            WHILE hora_inicio <= (SELECT hora_fim FROM empresa.colaboradores WHERE id_colaborador = colaborador_id) LOOP
                -- Verifica se não existe um registro na tabela empresa.agendas com o mesmo colaborador, data e hora agendados
                IF NOT EXISTS (
                    SELECT 1 FROM empresa.agendas a
                    WHERE a.colaborador_id = colaborador_id
                    AND a.data_agendada = data_atual
                    AND a.hora_agendada = hora_inicio
                ) THEN
                    -- Insere um novo registro na tabela empresa.agendas com os valores calculados
                    INSERT INTO empresa.agendas (data_agendada, hora_agendada, colaborador_id)
                    VALUES (data_atual, hora_inicio, colaborador_id);
                END IF;
                hora_inicio = hora_inicio + INTERVAL '30 MINUTE';
            END LOOP;
        END IF;
        data_atual = data_atual + INTERVAL '1 DAY';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT empresa.lanca_agenda_mensal(3, 7, 2023);
*/

----------------------------------------------------

/**
 * É necessário validar a data do agendamento, verificando se é um feriado, e não permitir seu lançamento;
 */

/**
 * Segue a criação da function para a verificação dos feriados;
 */

CREATE OR REPLACE FUNCTION empresa.verifica_agendamento() 
RETURNS trigger 
AS $$
BEGIN
	--extrai o dia da semana de data_agendada
    IF EXTRACT(DOW FROM NEW.data_agendada) IN (0, 6) THEN
        RAISE EXCEPTION 'Agendamentos em finais de semana não são permitidos.';
    END IF;
	--compara a data_agendada com os registros da tabela feriado
    IF EXISTS(SELECT * FROM empresa.feriados WHERE data_feriado = NEW.data_agendada) THEN
        RAISE EXCEPTION 'Agendamentos em feriados não são permitidos.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------

/**
 * Segue a criação da trigger para a restrição de da inserção e update de feriados na tabela empresa.agendas;
 */

CREATE TRIGGER restricao_agendamento
BEFORE
INSERT OR UPDATE ON	empresa.agendas
FOR EACH ROW
EXECUTE FUNCTION empresa.verifica_agendamento();

