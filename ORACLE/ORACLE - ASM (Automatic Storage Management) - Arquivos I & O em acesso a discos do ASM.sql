set lines 155
col path for a20
col NAME for a13
col READ_TIME for 9999999
col WRITE_TIME for 9999999
col WRITES for 9999999
col BYTES_READ for 999,999,999,999
col BYTES_WRITTEN for 9,999,999,999

select NAME, PATH, READS, WRITES, READ_ERRS, WRITE_ERRS, READ_TIME, WRITE_TIME, BYTES_READ, BYTES_WRITTEN from V$ASM_DISK_STAT
/