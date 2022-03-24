alter system flush shared_pool;

--DISCO
select b.username username,
       a.disk_reads reads,
       a.executions exec,
       a.disk_reads / decode(a.executions, 0, 1, a.executions) rds_exec_ratio,
       a.sql_text statemant
  from v$sqlarea a, dba_users b
 where a.parsing_user_id = b.user_id
   and a.disk_reads > 100000
 order by a.disk_reads desc;

-- MEMORIA
select b.username username,
       a.buffer_gets mem,
       a.executions exec,
       a.buffer_gets / decode(a.executions, 0, 1, a.executions) mem_exec_ratio,
       a.sql_text statemant
  from v$sqlarea a, dba_users b
 where a.parsing_user_id = b.user_id
   and a.buffer_gets > 100000
 order by a.buffer_gets desc;

--OS PIORES COMANDOS
select *
  from (select a.sql_text,
               rank() over(order by a.buffer_gets desc) as rank_bufgets,
               to_char(100 * ratio_to_report(a.buffer_gets) over(), '999.999') pct_bufgets
          from v$sql a)
 where rank_bufgets < 20;
