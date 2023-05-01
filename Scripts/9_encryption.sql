/**
 * É necessário criptografar os dados pessoais
 */

/**
 * Segue o comando para a criação da extesão pgcrypto, para a criptografia de dados; 
 */
CREATE EXTENSION IF NOT EXISTS pgcrypto;
----------------------------------------

/**
 * Segue o comando para adicionar uma nova coluna, para armazenar os dados criptografados;
 */
ALTER TABLE empresa.colaboradores ADD COLUMN cpf_crip bytea;
ALTER TABLE empresa.clientes ADD COLUMN cpf_crip bytea;
---------------------------------------

/**
 * segue os comandos para a criação da criptografia;
 */
UPDATE empresa.colaboradores SET cpf_crip = pgp_sym_encrypt(cpf, 'chave_camara_secreta');
UPDATE empresa.clientes SET cpf_crip = pgp_sym_encrypt(cpf, 'avada_kedavra');
--------------------------------------

/**
 *É necessário a exclusão dos regristros originais após a criptografia doa dados;
 */
ALTER TABLE empresa.colaboradores DROP COLUMN cpf;
ALTER TABLE empresa.clientes DROP COLUMN cpf;
--------------------------------------

/**
 * Segue o comando para a descriptografia dos dados;
 */
SELECT pgp_sym_decrypt(cpf_crip, 'chave_camara_secreta') AS cpf FROM empresa.colaboradores;
SELECT pgp_sym_decrypt(cpf_crip, 'avada_kedavra') AS cpf FROM empresa.clientes;

