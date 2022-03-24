-- 1- Mover tabelas de tablespace  
alter table NOME_TABELA move tablespace NOME_TABLESPACE;

-- 2- Reconstruir indices das tabelas que foram movidas:
alter index NOME_INDICE rebuild tablespace NOME_TABLESPACE;

