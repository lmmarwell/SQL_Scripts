select 'LOCK TABLE' lock_state,
       'COR_IDF' tabela,
       l.session_id,
       l.oracle_username,
       s.status,
       s.osuser,
       s.machine,
       s.program,
       s.module,
       s.logon_time,
       s.state
  from v$locked_object l,
       v$session       s
 where s.sid = l.session_id
   and l.object_id = (select object_id from user_objects o where object_name = 'COR_IDF')
