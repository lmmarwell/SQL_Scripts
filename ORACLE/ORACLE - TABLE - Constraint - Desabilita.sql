select 'alter table ' || a.table_name || ' disable CONSTRAINT ' || a.constraint_name || ';'
  from all_constraints a
 where a.constraint_type = 'R'
   and a.table_name = decode(upper('&Tabela'), 'all', a.table_name, upper('&Tabela'))
   and a.owner = upper('&Owner');

