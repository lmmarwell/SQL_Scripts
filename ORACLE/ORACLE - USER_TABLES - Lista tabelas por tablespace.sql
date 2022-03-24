  select t.table_name,
         t.tablespace_name
    from user_tables t
--   where t.table_name like '%AU%'
--   where t.table_name like '%&Tabela%' 
order by t.table_name,
         t.tablespace_name
