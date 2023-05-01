/**
 * É necessário criar uma rotina para importar um CSV com os serviços e feriado (servico.csv e feriado.csv);
 */

/**
 * Procedimento base para a importação dos arquivos;
 */
COPY temp_servico(descricao, valor)
	FROM '/home/jhonny/Downloads/servico.csv'
		DELIMITER ',' CSV HEADER;
-----------------------------------------------

/**
 * Criacao das tabelas temporárias para a importação dos arquivos .csv;
 */
CREATE TEMPORARY TABLE temp_servico (
  descricao TEXT,
  valor decimal
);

CREATE TEMPORARY TABLE temp_feriado (
  feriado TEXT,
  descricao TEXT
);
------------------------------------------------

/**
 * Segue os comandos para a importação do arquivo servico.csv.
 */
CREATE OR REPLACE FUNCTION empresa.importar_servicos_csv(caminho TEXT)
RETURNS VOID AS $$
BEGIN
  EXECUTE 'COPY temp_servico(descricao, valor)
           FROM ' || quote_literal(caminho) || '
           DELIMITER ' || quote_literal(',') || ' CSV HEADER;';
END;
$$ LANGUAGE plpgsql;

SELECT empresa.importar_servicos_csv('/home/jhonny/Downloads/servico.csv');
--------------------------------------------------

/**
 * Segue os comandos para a importação do arquivo feriado.csv.
 */
CREATE OR REPLACE FUNCTION empresa.importar_feriado_csv(caminho TEXT)
RETURNS VOID AS $$
BEGIN
  EXECUTE 'COPY temp_feriado(feriado, descricao)
           FROM ' || quote_literal(caminho) || '
           DELIMITER ' || quote_literal(',') || ' CSV HEADER;';
END;
$$ LANGUAGE plpgsql;

SELECT empresa.importar_feriado_csv('/home/jhonny/Downloads/feriado.csv');
-------------------------------------------------

/**
 * Movendo os dados da tabela temporária para a tabela empresa.servicos.
 */
INSERT INTO empresa.servicos (nome_servico,valor_servico)
	SELECT descricao, valor FROM temp_servico
	
