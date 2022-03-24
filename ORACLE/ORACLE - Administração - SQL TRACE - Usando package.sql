--------------------------------------------------------------------------------
-- Udando Parâmetro SQL_TRACE
--------------------------------------------------------------------------------
show parameter background_dump_dest;
alter session set tracefile_identifier='lmm_';
alter session set max_dump_file_size=UNLIMITED;
alter session set sql_trace=TRUE;
alter session set events '2423 trace name context forever, level 12';
alter session set sql_trace=FALSE;
alter session set events '2423 trace name context off';

--------------------------------------------------------------------------------
--Udando a Package DBMS_SUPPORT
--------------------------------------------------------------------------------
-- Para habilitar a geração de um trace estendido
BEGIN DBMS_SUPPORT.START_TRACE(true, true); END;

-- Para desabilitar a geração de trace estendido
BEGIN DBMS_SUPPORT.STOP_TRACE; END;

--------------------------------------------------------------------------------
-- Unando a Package DBMS_SESSION
--------------------------------------------------------------------------------
begin SYS.dbms_session.set_identifier; end;

-- Para habilitar a geração de um trace
BEGIN DBMS_SESSION.SET_SQL_TRACE(true); END;

-- Para configurar o identificar de cliente (que pode ser o nome da conta de um pool de conexões):
BEGIN DBMS_SESSION.SET_IDENTIFIER('MARWELL'); END;

--Para desabilitar a geração de trace extendido
BEGIN DBMS_SESSION.SET_SQL_TRACE(false); END;

--------------------------------------------------------------------------------
-- Unando a Package DBMS_SYSTEM
--------------------------------------------------------------------------------
--Para habilitar a geração de trace na sessão de outro usuário
BEGIN  DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(sid => 15, serial# => 2388, true); END;

-- Para desabilitar a geração de trace na sessão do mesmo usuário
BEGIN DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(sid => 15, serial# => 2388, false); END;

--------------------------------------------------------------------------------
-- Unando a Package DBMS_MONITOR
--------------------------------------------------------------------------------
-- Para habilitar a geração de trace na sessão de outro usuário
BEGIN DBMS_MONITOR.SESSION_TRACE_ENABLE(session_id => 19, serial_num => 53395, waits => true, binds => true); END;
	
--Para desabilitar a geração de trace na sessão do mesmo usuário
BEGIN DBMS_MONITOR.SESSION_TRACE_DISABLE(sid => 19, serial_num => 53395); END;


select *
  from v$session
where username is not null;


select s.sid,
       s.serial#,
       s.osuser,
       s.username,
       s.machine,
       s.logon_time,
       s.seconds_in_wait,
       s.last_call_et,
       'alter system kill session ''' || s.sid || ', ' || s.serial# || ''' immediate;' comando
  from v$session s
 where s.username is not null
--   and upper(s.osuser) = 'ONF00'
--   and upper(s.osuser) = 'ANA.PAULA'
--   and upper(s.osuser) = 'LMM00'
--   and upper(s.action) like 'TEST%'
 order by s.logon_time,
          s.sid,
          s.serial#;
