select to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') "time",
       substr(a.username, 1, 15) "username",
       a.osuser "os user",
       a.sid "session id",
       a.serial# "serial no",
       d.spid "process id",
       a.lockwait "lockwait",
       a.status "status",
       trunc(b.value / 1024) "pga (kb)",
       trunc(g.value / 1024) "pga max (kb)",
       trunc(e.value / 1024) "uga (kb)",
       a.module "module",
       substr(a.machine, 1, 15) "machine",
       a.program "program",
       substr(to_char(a.logon_time, 'dd-mon-yyyy hh24:mi:ss'), 1, 20) "time"
  from v$session  a,
       v$sesstat  b,
       v$statname c,
       v$process  d,
       v$sesstat  e,
       v$statname f,
       v$sesstat  g,
       v$statname h
 where a.paddr = d.addr
   and a.sid = b.sid
   and b.statistic# = c.statistic#
   and c.name = 'session pga memory'
   and a.sid = e.sid
   and e.statistic# = f.statistic#
   and f.name = 'session uga memory'
   and a.sid = g.sid
   and g.statistic# = h.statistic#
   and h.name = 'session pga memory max'
   and trim(a.username) = 'FISC33'
   and trim(a.STATUS) = 'INACTIVE'
 order by 1, 2;
