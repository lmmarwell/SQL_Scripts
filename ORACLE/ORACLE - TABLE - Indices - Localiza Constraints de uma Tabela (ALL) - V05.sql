select distinct
       -----
       cfk.owner,
       cfk.table_name      table_name_fk,
       ccf.constraint_name,
       ccf.column_name     column_fk,
       cfk.status,
       cfk.constraint_type,
       -----
       cpk.owner,
       cpk.table_name      table_name_pk,
       cpk.status,
       ccp.column_name     column_pk
       -----
  from sys.all_constraints  cfk,
       sys.all_cons_columns ccf,
       sys.all_constraints  cpk,
       sys.all_cons_columns ccp
 where ccp.position          = ccf.position
   and ccp.owner             = cpk.owner
   and ccp.constraint_name   = cpk.constraint_name
   and ccp.table_name        = cpk.table_name
   and cpk.constraint_name   = cfk.r_constraint_name
   and ccf.constraint_name   = cfk.constraint_name
   and ccf.table_name        = cfk.table_name
   and ccf.owner             = cfk.owner
   and cfk.constraint_type   = 'R'
   and (cfk.table_name       = upper('&Tabela_FK') or
        cpk.table_name       = upper('&Tabela_PK'))
 order by 1, 2, 4;

/*
 order by cfk.owner,
          cfk.table_name,
          --ccf.constraint_name,
          --cfk.constraint_type,
          cpk.owner,
          cpk.table_name;
*/

/*
 order by cpk.table_name,
          cfk.table_name;
*/