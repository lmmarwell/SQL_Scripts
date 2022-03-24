col path for a40
col name for a20
col label for a20
col diskgroup_name for a15
set pages 200
set lines 200
break on diskgroup_name
comp sum of total_mb on diskgroup_name
comp sum of free_mb on diskgroup_name
break on diskgroup_name
select b.name diskgroup_name, a.name, a.path, a.header_status, a.total_mb, a.free_mb from v$asm_disk a, v$asm_diskgroup b
where a.group_number=b.group_number
order by a.name;