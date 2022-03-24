Rem =============================================================================
Rem    NAME
Rem     waiters.sql - Verificacao de Lock de usuario
Rem 
Rem    NOTE - Mostra os usuarios que estao em lock
Rem	       
Rem    DESCRIPTION
Rem     Usuarios em lock
Rem     
Rem =============================================================================

set lines 200

col waiting_session 	form 99999
col holding_session 	form 99999
col username 		      form a25
col serial# 	      	form 99999999
col lock_type	      	form a30

select w.waiting_session,
			 s.username,
			 s.sid,
			 s.serial#,
			 w.holding_session,
			 s1.username,
			 s1.sid,
			 s1.serial#,
			 w.lock_type
	from dba_waiters w, v$session s, v$session s1
 where w.waiting_session = s.sid
	 and w.holding_session = s1.sid
/

