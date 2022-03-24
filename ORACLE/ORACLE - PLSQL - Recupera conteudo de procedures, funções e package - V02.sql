select aa.owner,
       aa.package_name,
       aa.subprogram_id,
       aa.object_name,
       aa.sequence,
       aa.argument_name,
       aa.in_out,
       aa.data_type,
       aa.data_length,
       aa.data_precision,
       aa.pls_type
  from all_arguments aa
 where owner = 'S5B'
   and aa.package_name = 'SISTEMA_INTEGRADO_TESTE'
-- where aa.object_name = 'XR_EXECUTA_TESTE'
-- where aa.package_name = 'XR_EXECUTA_TESTE'
 order by 1, 2, 3, 4, 5;
