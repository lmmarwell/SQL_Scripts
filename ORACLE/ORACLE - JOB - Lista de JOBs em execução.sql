select * from v$session where username is not null order by logon_time, sid

select r.sid, r.job, r.this_date, r.this_sec, substr(what, 1, 40) what
  from dba_jobs_running r, dba_jobs j
 where r.job = j.job;
