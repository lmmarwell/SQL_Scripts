############################################################
## Verificar DB_LINKS utilizados em CORPO de Objetos
############################################################


set lines 200
col owner form a20
col synonym_name form a30
col table_owner form a20
col table_name form a30
col db_link for a28

select owner, synonym_name, table_owner, table_name, db_link
from dba_synonyms
where db_link is not null
/

set pages 200
col owner for a10
col db_link for a27
col username for a15
col host for a15

select owner, db_link, username, host from dba_db_links
/

set long 50000
col owner form a20
col name form a30
col type form a30


undef db_link

accept db_link prompt 'Qual o DB_LINK que deseja verificar ? '

ttitle left '&db_link' skip 2

select distinct owner, name, type
from dba_source
where upper(text) like upper('%&db_link%')
/
ttitle off
