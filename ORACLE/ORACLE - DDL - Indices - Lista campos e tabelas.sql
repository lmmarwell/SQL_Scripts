--------------------------------------------------------------------------
select c.column_name
  from sys.all_tables t,
       sys.all_tab_columns c
 where c.owner = t.owner
--   and c.column_name like '%TEL%'
   and c.table_name = t.table_name
   and t.table_name = 'PROJECT';
--------------------------------------------------------------------------
select i.*
  from sys.all_tables t,
       sys.all_indexes i
 where i.index_name like '%TEL%'
   and i.owner = t.owner
   and i.table_name = t.table_name
   and t.table_name = 'EMITENTE_COMPLETO'
 order by i.index_name;
--------------------------------------------------------------------------
select i.index_name, c.*
  from sys.all_tables t,
       sys.all_indexes i,
       sys.all_ind_columns c
 where c.index_owner = i.owner
   and c.index_name = i.index_name
--   and c.column_name like 'NU_TELEFONE%'
--   and i.index_name like '%TEL%'
   and i.owner = t.owner
   and i.table_name = t.table_name
   and t.table_name = 'PROJECT'
 order by i.index_name;
--------------------------------------------------------------------------
select owner,
       index_name
  from sys.all_indexes
--------------------------------------------------------------------------
select distinct
       owner
  from sys.all_indexes
--------------------------------------------------------------------------
select *
  from sys.index_stats;
--------------------------------------------------------------------------
