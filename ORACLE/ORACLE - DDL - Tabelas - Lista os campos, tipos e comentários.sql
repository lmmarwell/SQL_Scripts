--------------------------------------------------------------------------------
-- Lista Objetos do OWNER informado
--------------------------------------------------------------------------------
select ob.object_name    nm_objeto,
       ob.object_type    nm_tipo,
       tc.column_id      nu_col,
       tc.column_name    nm_col,
       tc.data_type      tp_dados,
       tc.data_length    nu_tamanho,
       tc.data_precision nu_precisao,
       tc.data_default   tx_default,
       cm.comments       tx_comentario
  from sys.all_objects      ob,
       sys.all_tab_columns  tc,
       sys.all_col_comments cm 
 where cm.owner       = tc.owner
   and cm.table_name  = tc.table_name
   and cm.column_name = tc.column_name
   and tc.owner       = ob.owner
   and tc.table_name  = ob.object_name
   and ob.owner = 'AD_LUCIANO'
 order by ob.object_name,
          tc.column_id;
--------------------------------------------------------------------------------