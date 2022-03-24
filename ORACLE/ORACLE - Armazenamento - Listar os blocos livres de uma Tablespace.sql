@free
prompt Blocos livres na tablespace. Informe a "TABLESPACE"
set head on
compute sum of Total on report
break on report
select TABLESPACE_NAME, CEIL(BYTES/1024/1024) TAMANHO , count(*) QTD , ceil(bytes/1024/1024)*count(*) TOTAL
from dba_free_space
where tablespace_name LIKE '%&TABLESPACE%'
GROUP BY tablespace_name, CEIL(BYTES/1024/1024)
ORDER BY 1
/

