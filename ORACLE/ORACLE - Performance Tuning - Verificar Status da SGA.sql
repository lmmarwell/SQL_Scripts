

col name format a40 

select name, bytes 
from v$sgastat 
/ 

set head off 

select 'total of SGA '||sum(bytes) 
from v$sgastat ;
