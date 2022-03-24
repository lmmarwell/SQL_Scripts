--------------------------------------------------------------------------
select sas.owner,
       sas.name,
       lower(sas.owner || '.' || sas.name) object,
       sas.type,
       sas.line,
       sas.text
  from sys.all_source sas
-- where sas.name = upper('&name')
-- where upper(sas.name) like upper('%&name%')
--   and sas.type = upper('&type')
--   and upper(sas.text) like upper('%&text%')
 where upper(sas.text) like upper('%&text%')
   and sas.owner = 'EXT'
 order by sas.owner,
          sas.name,
          sas.type,
          sas.line;
--------------------------------------------------------------------------
select aa.owner,
       aa.package_name,
       aa.object_name,
       aa.sequence,
       aa.argument_name,
       aa.in_out,
       aa.data_type,
       aa.data_length,
       aa.data_precision,
       aa.pls_type
  from all_arguments aa
-- where owner = 'S5B'
--   and aa.package_name = 'XR_EXECUTA_TESTE'
-- where aa.object_name = 'XR_EXECUTA_TESTE'
 where aa.package_name = 'XR_EXECUTA_TESTE'
 order by 1, 2, 3, 4;
--------------------------------------------------------------------------
