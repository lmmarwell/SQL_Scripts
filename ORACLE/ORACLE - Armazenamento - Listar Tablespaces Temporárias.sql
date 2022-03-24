set lines 200
set pages 200
comp sum of total_bytes on report
comp sum of bytes_free on report
comp sum of bytes_used on report
break on report

col name for a38
col total_bytes for 999,999,999,999,999
col bytes_free for 999,999,999,999,999
col bytes_used for 999,999,999,999,999
col tablespace_name for a12

select b.tablespace_name, a.NAME, a.STATUS, a.BYTES as total_bytes, b.BYTES_USED, b.BYTES_FREE
from v$tempfile a, V$TEMP_SPACE_HEADER b
where a.FILE# = b.FILE_ID
/
