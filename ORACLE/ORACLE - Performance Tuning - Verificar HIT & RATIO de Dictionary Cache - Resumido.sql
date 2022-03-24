

prompt 
prompt Data Dictionary Ratio
prompt 
prompt Considere manter este valor abaixo de 5%
prompt Caso esteja abaixo, aumentar SHARED_POOL_SIZE
column dictcache format 999.99 heading 'Dictionary Cache | Ratio %' 

select sum(getmisses) / (sum(gets)+0.00000000001) * 100 dictcache 
from v$rowcache ;