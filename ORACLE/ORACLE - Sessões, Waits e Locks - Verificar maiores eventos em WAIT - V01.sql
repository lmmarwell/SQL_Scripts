column class heading 'Class Type' 
column count heading 'Times Waited' format 99,999,999 
column time heading 'Total Times' format 99,999,999 

select class,
       count,
       time
  from v$waitstat
 where count > 0
 order by class;
