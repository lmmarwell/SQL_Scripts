select sas.owner,
       sas.name,
       sas.type,
       sas.line,
       sas.text
  from sys.all_source sas
-- where sas.name = upper('&name')
-- where upper(sas.name) like upper('%&name%')
--   and sas.type = upper('&type')
--   and upper(sas.text) like upper('%&text%')
 where upper(sas.text) like upper('%&text%')
--   and sas.owner = 'EMI'
 order by sas.owner,
          sas.name,
          sas.type,
          sas.line;
