select distinct
       cfk.owner || '.' || cfk.table_name table_name_fk,
       ccf.constraint_name                constraint_name,
       ccf.column_name                    column_fk,
       cfk.status                         status,
       cfk.constraint_type                constraint_type,
       cpk.owner || '.' || cpk.table_name table_name_pk,
       cpk.status                         status,
       ccp.column_name                    column_pk     
  from all_constraints  cfk,
       all_cons_columns ccf,
       all_constraints  cpk,
       all_cons_columns ccp
 where ccp.position          = ccf.position
   and ccp.owner             = cpk.owner
   and ccp.constraint_name   = cpk.constraint_name
   and ccp.table_name        = cpk.table_name
   and cpk.constraint_name   = cfk.r_constraint_name
   and ccf.constraint_name   = cfk.constraint_name
   and ccf.table_name        = cfk.table_name
   and ccf.owner             = cfk.owner
   and cfk.constraint_type   = 'R'
   and (cfk.table_name = upper('&Tabela') or cpk.table_name = upper('&Tabela'))
 order by cfk.owner || '.' || cfk.table_name,
          ccf.constraint_name,
          cfk.constraint_type,
          cpk.owner || '.' || cpk.table_name;