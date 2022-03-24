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
order by to_char(logon_time, 'dd-mon-yyyy hh24:mi');
