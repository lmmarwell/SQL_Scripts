select sas.owner,
       sas.type,
       sas.name,
       max(sas.line) line
--       sas.text
  from sys.all_source sas
 where sas.owner = 'FISC33'
--   and sas.name = upper('&name')
--   and sas.type = upper('&type')
--   and upper(sas.name) like upper('%&name%')
   and upper(sas.text) like upper('%&text%')
--   and upper(sas.text) like '%BEG%CUS%'
 group by sas.owner,
          sas.type,
          sas.name
 order by sas.owner,
          sas.type,
          sas.name;
--------------------------------------------------------------------------------
select sas.owner,
       sas.name,
       sas.type,
       max(sas.line) line
  from sys.all_source sas
 where sas.owner = 'FISC33'
--   and sas.name = upper('&name')
--   and sas.type = upper('&type')
--   and upper(sas.name) like upper('%&name%')
   and upper(sas.text) like upper('%&text%')
 group by sas.owner,
          sas.type,
          sas.name
 order by sas.owner,
          sas.type,
          sas.name;
--------------------------------------------------------------------------------
select sas.owner,
       sas.type,
       sas.name,
       sas.line,
       sas.text
  from sys.all_source sas
 where sas.owner = 'FISC33'
--   and sas.name = upper('&name')
--   and sas.type = upper('&type')
--   and upper(sas.name) like upper('%&name%')
   and upper(sas.text) like upper('%&text%')
 order by sas.owner,
          sas.type,
          sas.name,
          sas.line;
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
select sas.name,
       sas.type,
       sas.line,
       sas.text
  from sys.all_source sas
 order by sas.name,
          sas.type,
          sas.line;
--------------------------------------------------------------------------------
