--------------------------------------------------------------------------------
/*
select scp.table_name,
       suc.constraint_name, 
       ucc.column_name,
       suc.status
  from sys.user_cons_columns ucc,
       sys.user_constraints  scp,
       sys.user_constraints  suc
 where scp.owner           = suc.r_owner
   and scp.constraint_name = suc.r_constraint_name
   and ucc.owner           = suc.owner
   and ucc.constraint_name = suc.constraint_name
   and ucc.table_name      = suc.table_name
   and suc.constraint_type = 'R'
   and suc.owner           = 'FISC33'
   and suc.status          <> '&Status'
   and suc.constraint_name = '&Constraint'
   and suc.table_name      = '&Tabela'
union all
select suc.table_name,
       suc.constraint_name,
       ucc.column_name,
       suc.status
  from sys.user_cons_columns ucc,
       sys.user_constraints  scp,
       sys.user_constraints  suc
 where ucc.owner             = suc.owner
   and ucc.constraint_name   = suc.constraint_name
   and ucc.table_name        = suc.table_name
   and suc.r_owner           = scp.owner
   and suc.r_constraint_name = scp.constraint_name
   and suc.constraint_type   = 'R'
   and suc.status            <> '&Status'
   and suc.constraint_name   = '&Constraint'
   and scp.constraint_type in ('P', 'U')
   and scp.owner             = 'FISC33'
   and scp.table_name        = '&Tabela'
 order by 1, 2, 3, 4;
*/
--------------------------------------------------------------------------------
select scp.table_name,
       suc.constraint_name, 
       ucc.column_name,
       suc.r_constraint_name,
       suc.status
  from sys.user_cons_columns ucc,
       sys.user_constraints  scp,
       sys.user_constraints  suc
 where scp.owner           = suc.r_owner
   and scp.constraint_name = suc.r_constraint_name
   and ucc.owner           = suc.owner
   and ucc.constraint_name = suc.constraint_name
   and ucc.table_name      = suc.table_name
--   and suc.status not like 'ENABLE%'
--   and suc.constraint_name = 'SAP_ITF_TIPO_IMPOSTO_COR_FK'
--   and suc.table_name        = 'SAP_ITF_IDF_CIAP'
   and suc.owner           = 'FISC33'
   and suc.constraint_type = 'R'
   and suc.table_name in (select open.object_name
                            from user_objects open
                           where object_type = 'TABLE'
                             and (open.object_name like '%SAP_ITF%' or open.object_name like '%ITF_%' or
                                 open.object_name like '%ITFIN_%' or open.object_name like '%SYNITF_%')
                             and open.object_name not like 'ITFIN_ANX%'
                             and open.object_name not like 'SYN_ITF%'
                             and open.object_name not like '%APPL%')
union
select suc.table_name,
       suc.constraint_name,
       ucc.column_name,
       suc.r_constraint_name,
       suc.status
  from sys.user_cons_columns ucc,
       sys.user_constraints  scp,
       sys.user_constraints  suc
 where ucc.owner             = suc.owner
   and ucc.constraint_name   = suc.constraint_name
   and ucc.table_name        = suc.table_name
   and suc.r_owner           = scp.owner
   and suc.r_constraint_name = scp.constraint_name
   and suc.constraint_type   = 'R'
--   and suc.status not like 'ENABLE%'
--   and suc.constraint_name   = 'SAP_ITF_TIPO_IMPOSTO_COR_FK'
--   and scp.table_name        = 'SAP_ITF_IDF_CIAP'
   and scp.owner             = 'FISC33'
   and scp.constraint_type in ('P', 'U')
   and scp.table_name in (select open.object_name
                            from user_objects open
                           where object_type = 'TABLE'
                             and (open.object_name like '%SAP_ITF%' or open.object_name like '%ITF_%' or
                                 open.object_name like '%ITFIN_%' or open.object_name like '%SYNITF_%')
                             and open.object_name not like 'ITFIN_ANX%'
                             and open.object_name not like 'SYN_ITF%'
                             and open.object_name not like '%APPL%')
 order by 1, 2, 3, 4
-- order by 2, 1, 3, 4
--------------------------------------------------------------------------------
