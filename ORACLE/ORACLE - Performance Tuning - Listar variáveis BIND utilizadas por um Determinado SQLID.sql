
 select *
 from dba_hist_sqlbind
 where sql_id = '<numero_sqlid>'
 order by last_captured,
 position