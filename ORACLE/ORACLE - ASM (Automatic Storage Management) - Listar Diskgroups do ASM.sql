set lines 90
set pages 200
col name for a25
col total_mb for 999999999
col free_mb for 999999999
select name, total_mb, free_mb, round((free_mb/total_mb)*100,2) "% FREE"
 from v$asm_diskgroup
/
