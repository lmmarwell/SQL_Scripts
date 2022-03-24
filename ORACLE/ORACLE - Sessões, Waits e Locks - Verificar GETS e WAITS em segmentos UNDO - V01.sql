break on report 

compute sum of gets waits writes on report 

select rownum,
       extents,
       rssize,
       xacts,
       gets,
       waits,
       writes
  from v$rollstat
 order by rownum;
