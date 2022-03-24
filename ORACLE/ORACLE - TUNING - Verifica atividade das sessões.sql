   select logon_time, sid, serial#, audsid, status, schemaname,
          osuser, username, program, event
     from v$session
    where username is not null
      and osuser = 'luciano.marwell'
 order by program, logon_time;
-- order by logon_time, sid, serial#, audsid, status, schemaname,
--          osuser, username, program, event

   select logon_time, sid, serial#, audsid, status, schemaname,
          osuser, username, program, event
     from v$session
    where username = user
 order by logon_time, sid, serial#, audsid, status, schemaname,
          osuser, username, program, event;

   select logon_time, sid, serial#, audsid, status, schemaname,
          osuser, username, program, event
     from v$session
    where username is not null
      and status = 'ACTIVE'
 order by logon_time, sid, serial#, audsid, status, schemaname,
          osuser, username, program, event;
