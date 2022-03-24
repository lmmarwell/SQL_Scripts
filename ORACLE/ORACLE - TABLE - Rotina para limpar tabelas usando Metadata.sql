select 'truncate table ' || lower(t. owner || '.' || t.table_name) || ' drop storage;' || --chr(13) || chr(13) ||
       'insert into '    || lower(t. owner || '.' || t.table_name) || ' ' ||
       'select * from '  || lower(t. owner || '.' || t.table_name) || '@' || lower(d.db_link) || ' cn;'
  from sys.all_tables t,
       sys.all_db_links d
 where t.owner = 'S5B'
   and t.table_name like 'CORTE_NEUROTECH%'
   and d.db_link = 'TL05'
--   and d.db_link in ('TL01', 'TL04', 'TL05', 'TL10')
/*
select *
  from sys.all_db_links d
 where d.db_link in ('TL01', 'TL04', 'TL05', 'TL10')
*/
