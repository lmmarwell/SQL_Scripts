column username format a15;
column program format a20;
column machine format a10;
column n_seconds format a6;

select username,
       v$session.sid,
       v$session.serial#,
       ltrim(v$session_wait.seconds_in_wait) as n_seconds,
       process,
       machine,
       terminal,
       program
  from v$session, v$session_wait
 where v$session.sid = v$session_wait.sid
   and v$session.sid in (select v$lock.sid from v$lock where v$lock.lmode = 6);

select s.*,
       q.*,
       replace(q.sql_fulltext, chr(0)) sql_text
  from gv$session s,
       gv$sql q
 where s.sql_address    = q.address
   and s.sql_hash_value = q.hash_value
   and s.sid            = :sid;

  
select username,
       v$session.sid,
       v$session.serial#,
       v$session.terminal,
       status,
       'alter system kill session ' || '''' || v$session.sid || ', ' || v$session.serial# || '''' || ' immediate;'
  from v$session;

alter system kill session '11,24' immediate; --SID/SERIAL
