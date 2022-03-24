select f.tablespace_name,
       to_char((t.total_space - f.free_space), '999,999') USED_MB,
       to_char(f.free_space, '999,999') FREE_MB,
       to_char(t.total_space, '999,999') TOTAL_MB,
       to_char((round((f.free_space / t.total_space) * 100)), '999') || ' %' "FREE_%"
  from (select tablespace_name,
               round(sum(blocks * (select value / 1024
                                     from v$parameter
                                    where name = 'db_block_size') / 1024)) free_space
          from dba_free_space
         group by tablespace_name) f,
       (select tablespace_name, round(sum(bytes / 1048576)) total_space
          from dba_data_files
         group by tablespace_name) t
 where f.tablespace_name = t.tablespace_name
 order by f.tablespace_name;
