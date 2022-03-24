select sid,
       serial#,
       osuser,
       program,
       schemaname,
       lockwait,
       username,
       to_char(logon_time, 'dd-mon-yyyy hh24:mi'),
       status
  from v$session
 where status = 'ACTIVE'
   and username in ('FISC33', 'FISCAL33_02', 'OPS$SNCDEV', 'OPS$SNCPRD')
--   and nvl(osuser,'*') <> 'sncprd'
--   and program  is null  -- 18 24 30
 order by to_char(logon_time, 'dd-mon-yyyy hh24:mi')
--------------------------------------------------------------------------------
select sid,
       trunc((sofar / totalwork) * 100, 2) "%_complete",
       opname,
       trunc(time_remaining / 60, 2) tr,
       target,
       message
  from v$session_longops
 where (sofar / totalwork) * 100 <> 100
   and totalwork <> 0
 order by sid, start_time
--------------------------------------------------------------------------------
update syn_job_cadastro set job_pai = 13475 where id = 13471
--------------------------------------------------------------------------------
select * from user_tables where table_name like '%LOG%'
--------------------------------------------------------------------------------
select *
  from user_constraints
 where r_constraint_name in
       (select constraint_name
          from user_constraints
         where table_name = 'SYN_CRG_EXEC_LOG'
           and constraint_type in ('P', 'U'))
--------------------------------------------------------------------------------
select * from user_jobs
--------------------------------------------------------------------------------
select u.sid,
       u.serial#,
       s.sql_text,
       'alter system KILL SESSION ' || chr(39) || u.sid || ',' || u.serial# || chr(39) || ';' "KILL COMMAND"
  from v$sql s, v$session u
 where s.hash_value = u.sql_hash_value
   and u.sid = &valor_sid
--------------------------------------------------------------------------------
select bon_empresa, sis_codigo, sistema
  from cor_sistema
 where bon_empresa in ('TELEMAR', 'TELEFONICA', 'CTBC', 'BRT')
 order by bon_empresa, sis_codigo
--------------------------------------------------------------------------------
select distinct arquivo, dt_fato_gerador_imposto
  from bon_log_itf_idf
 where dt_fato_gerador_imposto >= '01-may-2004'
   and arquivo like 'IDF_ENV%'
--------------------------------------------------------------------------------
select count(1) from itf_idf
--------------------------------------------------------------------------------
select *
  from bon_log_itf_idf
 where arquivo = 'IDF_ENV_ICMS.EOT041.200404261020210001M02.R200405'
--------------------------------------------------------------------------------
select 'dbms_job.remove(''' || job || ''');'
  from user_jobs
 where log_user = 'OPS$SNCPRD'
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- VERIFICA O PROCESSO ATUAL
--------------------------------------------------------------------------------
select sid, sql_text
  from v$session ses, v$sqltext txt
 where txt.address = ses.sql_address
   and txt.hash_value = ses.sql_hash_value
   and sid in
       (select sid
          from v$session
         where status = 'ACTIVE'
           and username in ('FISC33' /*,'FISCAL33_02','OPS$SNCDEV'*/))
 order by sid, piece
--------------------------------------------------------------------------------
select sid, sql_text
  from v$session ses, v$sqltext txt
 where txt.address = ses.sql_address
   and txt.hash_value = ses.sql_hash_value
   and sid = 17
 order by sid, piece
--------------------------------------------------------------------------------
select * from user_objects where object_name like 'SYN_JOB'
--------------------------------------------------------------------------------
create public synonym syn_job for fisc33.syn_job
--------------------------------------------------------------------------------
select c.sid,
       c.serial#,
       c.username,
       a.object_id,
       b.object_name,
       c.program,
       c.status,
       d.name,
       c.osuser
  from v$locked_object a, all_objects b, v$session c, audit_actions d
 where a.object_id = b.object_id
   and a.session_id = c.sid(+)
   and c.command = d.action
--------------------------------------------------------------------------------
select job,
       this_date,
       this_sec,
       next_date,
       next_sec,
       trunc(total_time) total_time,
       failures,
       what
  from user_jobs
 order by 1
--------------------------------------------------------------------------------
begin
  syn_job.executa(12334);
end;
--------------------------------------------------------------------------------
begin
  syn_job.executa(12335);
end;
--------------------------------------------------------------------------------
begin
  syn_job.executa(12891);
end;
--------------------------------------------------------------------------------
select to_char(sysdate, 'hh24:mi') from dual
--------------------------------------------------------------------------------
select descricao,
       vl_icms_apropriado + vl_icms_dif_apropriado,
       vl_saldo_remanescente
  from ciap_controle_ciap
 where est_codigo = 'C0010001FX'
--------------------------------------------------------------------------------
net = 2430-1011
--------------------------------------------------------------------------------
select serie_subserie, numero, dt_fato_gerador_imposto
  from cor_dof
 where sis_codigo = 'SAP'
   and emitente_pfj_codigo = 'C0010006FX'
   and dt_fato_gerador_imposto between '01-dec-2002' and '31-dec-2002'
 order by 1, 2
--------------------------------------------------------------------------------
select count(1) total, sum(decode(failures, null, 0, 1)) falhas from user_jobs
--------------------------------------------------------------------------------
select count(1) from user_jobs
--------------------------------------------------------------------------------
select to_char(sysdate, 'hh24:mi') from dual
--------------------------------------------------------------------------------
select conteudo
  from syn_prcger_impressao
 where prcger_id = 42701
 order by pagina, linha
--------------------------------------------------------------------------------
select to_char(sysdate, 'mi') from dual
--------------------------------------------------------------------------------
select * from user_tables where table_name like 'TMP%'
--------------------------------------------------------------------------------
select *
  from fis_arqmag
 where est_codigo = 'C0010006FX'
   and dt_escrit between '01-jun-2001' and '30-jun-2001'
--------------------------------------------------------------------------------
ERROR:
ORA-01034: ORACLE not available
--------------------------------------------------------------------------------