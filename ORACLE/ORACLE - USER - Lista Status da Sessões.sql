select u.name,
       d.account_status,
       d.lock_date,
       to_char(u.ctime, 'dd/mm/yyyy hh24:mi:ss') criao,
       to_char(u.ptime, 'dd/mm/yyyy hh24:mi:ss') modificacao
  from sys.user$ u,
       sys.dba_users d
 where u.name    =  d.username
   and u.ctime   =  d.created
   and d.created >= to_date('01/01/2000', 'dd/mm/yy')
   and d.created <= to_date('31/12/2011', 'dd/mm/yy')
 order by d.created;
