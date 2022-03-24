--------------------------------------------------------------------------------
alter system flush shared_pool;
--------------------------------------------------------------------------------
select b.parsing_schema_name,
       --to_char(systimestamp, 'dd/mm/yyyy hh24:mi:ss.ffff') as amostra,
       to_char(sysdate, 'dd/mm/yyyy') as amostra,
       null as status,
       null as doc,
       a.sql_id,
       a.sql_fulltext,  
       b.rows_processed,
       c.value_string,
       a.last_active_time,
       a.executions,
       a.elapsed_time/1000000 as elapsed_time,
       a.cpu_time/1000000 as cpu_time,
       a.application_wait_time/1000000 as avg_wait,
       a.concurrency_wait_time/1000000 as concurrency_wait_time,
       a.cluster_wait_time/1000000 as cluster_wait_time,
       a.user_io_wait_time/1000000 as user_io_wait_time,
       a.plsql_exec_time/1000000 as plsql_exec_time,
       a.avg_hard_parse_time/1000000 as avg_hard_parse_time,
       b.sorts,
       b.command_type,
       b.optimizer_cost,
       b.disk_reads,
       b.buffer_gets,
       b.module,
       b.sorts,
       b.fetches,
       b.users_executing
  from v$sqlstats a,
       v$sql b,
       v$sql_bind_capture c
 where c.sql_id = b.sql_id
   and a.sql_id = b.sql_id
   --and avg_hard_parse_time/1000000 > 1
   and parsing_schema_name = 'SANFOM' 
 order by elapsed_time desc;
-------------------------------------------------------------------------------- 
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
 where a.sql_id = b.sql_id
   and b.parsing_schema_name = 'SANFOM'
--   and a.avg_hard_parse_time/1000000 > 0.1
 order by elapsed_time desc;
--------------------------------------------------------------------------------