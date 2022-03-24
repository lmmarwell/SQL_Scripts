set feed off
set pagesize 0
set termout off
spool make__.sql

select 'set termout on' from dual;
select 'set echo on' from dual;

select 'alter ' || Rtrim(object_type) || ' ' || rtrim(object_name) ||
       ' compile;'
From user_objects
Where status = 'INVALID' and object_type not in ('PACKAGE BODY')
;

select 'alter package ' ||  rtrim(object_name) ||
       ' compile body;'
From user_objects
Where status = 'INVALID' and object_type in ('PACKAGE BODY')
;

spool off
@make__
set echo off
set termout off
host rm make__.sql
set feed on
set pagesize 24
set termout on

/*

SELECT * FROM USER_OBJECTS WHERE STATUS = 'INVALID'

SELECT 'ALTER ' || RTRIM(OBJECT_TYPE) || ' ' || RTRIM(OBJECT_NAME) || ' COMPILE; '
FROM USER_OBJECTS WHERE OBJECT_TYPE NOT IN ('PACKAGE BODY') AND STATUS = 'INVALID'


SELECT 'ALTER PACKAGE ' || RTRIM(OBJECT_NAME) || ' COMPILE BODY; '
FROM USER_OBJECTS WHERE OBJECT_TYPE  IN ('PACKAGE BODY') AND STATUS = 'INVALID'

*/