
prompt SORT AREA SIZE VALUES: 
prompt 
prompt Para garantir que a area de sort seja corretamente usada deve-se manter
prompt espaco suficiente na tablespace temporaria correspondente.
prompt Manter o parametro sort_area_retained_size = 0 ira forçar o oracle a liberar
prompt a area de SORT imediatamente quando uma instrucao SQL com ordenacao terminar.
prompt Isso ajuda reduzir consumo desnecessario de area TEMPORARIA
prompt 

column value format 999,999,999 

select 'INIT.ORA sort_area_size: '||value 
from v$parameter 
where name like 'sort_area_size' 
/ 

select a.name, value 
from v$statname a, v$sysstat 
where a.statistic# = v$sysstat.statistic# 
and a.name in ('sorts (disk)', 'sorts (memory)', 'sorts (rows)') 
;