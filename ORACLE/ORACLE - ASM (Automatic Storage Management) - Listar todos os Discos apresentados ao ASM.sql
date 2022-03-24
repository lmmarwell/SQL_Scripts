col state for a10
col name for a10
col failgroup for a10
col label for a15
col path for a15

set lines 200
set pages 200

select GROUP_NUMBER, DISK_NUMBER, MOUNT_STATUS, MODE_STATUS, STATE, REDUNDANCY, TOTAL_MB, FREE_MB, NAME, FAILGROUP, LABEL, PATH, to_char(MOUNT_DATE,'DD-MM-YYYY HH24/:MI/:SS') from v$asm_disk
/
