alter system flush shared_pool;
--------------------------------------------------------------------------------
select --a.sql_id,
       b.parsing_schema_name          owner,
       --to_char(sysdate, 'dd/mm/yyyy') amostra,
       a.executions                   executions,
       a.sql_fulltext,
       --retorna os parâmetros utilizados no SQL
       (select wm_concat(chr(13) || name || ' = ' || nvl(value_string, 'NULL')) from v$sql_bind_capture bc where bc.sql_id = b.sql_id) param_bind,
       b.rows_processed,
       --a.last_active_time,
       --b.module,
       b.elapsed_time,
       --b.fetches,
       b.users_executing
  from v$sqlstats a, v$sql b
 where a.sql_id              = b.sql_id
   and b.parsing_schema_name = 'SANFOM'
--   and b.rows_processed = 0
--   and a.avg_hard_parse_time/1000000 > 0.1
 order by elapsed_time desc;
--------------------------------------------------------------------------------

/*
select sys_context('USERENV', 'SERVER_HOST')   "Nome do Servidor",
       sys_context('USERENV', 'INSTANCE_NAME') "Instância",
       sys_context('USERENV', 'HOST')          "Máquina Cliente",
       sys_context('USERENV', 'IP_ADDRESS')    "IP Cliente",
       sys_context('USERENV', 'OS_USER')       "Usuário SO",
       sys_context('USERENV', 'SESSION_USER')  "Usuário BD",
       sys_context('USERENV', 'GROUP_NO') "User Group" 
  from dual;
*/