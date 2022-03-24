Report por Criacao de Objects
###############################################

set pages 500
set lines 200
col os_username for a11
col username for a11
col obj_name for a22
col data for a20
col terminal for a19
col PRIV_USED for a17
col action_name for a15

select OS_USERNAME, terminal, USERNAME, to_char(TIMESTAMP,'DD/MM/YYYY HH24:MI:SS') as DATA, OBJ_NAME, ACTION_NAME, PRIV_USED
from  dba_audit_object
/


Opcoes que estao sendo Auditadas
###############################

select * from dba_stmt_audit_opts
order by 3
/




Opcoes da AUD$ (Incluindo PL/SQL EXECUTE)
############################################

select USERNAME, to_char(TIMESTAMP,'DD/MM/YYYY HH24:MI:SS') as DATA, OBJ_NAME, ACTION_NAME, PRIV_USED from dba_audit_trail
order by 2
/



select object_name from dba_objects
where owner='SYS'
and object_name like '%AUD%$%';