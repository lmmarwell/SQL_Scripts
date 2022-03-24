--------------------------------------------------------------------------
select sas.owner,
       sas.name,
       lower(sas.owner || '.' || sas.name) object,
       sas.type,
       sas.line,
       sas.text
  from sys.all_source sas
 where upper(sas.text) like upper('%&text%')
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
 where aa.package_name = 'PR_CALCULA_OBRIGATORIEDADE'
 order by 1, 2, 3, 4;
--------------------------------------------------------------------------
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
 where aa.package_name = 'PR_CALCULA_OBRIGATORIEDADE'
 order by 1, 2, 3, 4, 5;
