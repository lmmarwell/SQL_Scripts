select 'LOCK TABLE' lock_state,
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
       v$session       s,
       user_objects    o
 where s.sid = l.session_id
	 and l.object_id = o.object_id;
