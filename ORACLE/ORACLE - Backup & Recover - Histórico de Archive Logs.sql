select 'Periodo historico de switch/archivelog (dias)' as archive_stat
    , round( max(first_time) - min(first_time) )
    as archive_value
    from v$log_history
union all
select 'Changes no periodo' as archive_stat
    , round( max(next_change#) - min(first_change#) )
    as archive_value
    from v$log_history
union all
select 'Changes por dia' as archive_stat
     , round( ( max(first_change#) - min(first_change#) )
            / ( max(first_time)    - min(first_time)    ) )
    as archive_value
  from v$log_history
union all
select 'Switches no periodo' as archive_stat
     , max(sequence#) - min(sequence#) + 1
    as archive_value
  from v$log_history
union all
select 'Switches por dia' as archive_stat
     , round( ( max(sequence#) - min(sequence#) + 1 )
            / ( max(first_time)    - min(first_time)    ) )
    as archive_value
  from v$log_history
union all
select 'Volume de Archivelog (MBytes) no periodo'
     , sum(blocks*block_size)/1024/1024
    as archive_value
  from ( select max(blocks) as blocks, max(block_size) as block_size
              , max(first_time) as first_time
         from v$archived_log where ARCHIVED = 'YES' group by SEQUENCE# )
union all
select 'Volume de Archivelog (MBytes) por dia'
     , round( sum(blocks*block_size)/1024/1024
            / ( max(first_time) - min(first_time) ) )
    as archive_value
  from ( select max(blocks) as blocks, max(block_size) as block_size
              , max(first_time) as first_time
         from v$archived_log where ARCHIVED = 'YES' group by SEQUENCE# )
union all
select 'Switches nas ultimas 24 horas'
     , max(sequence#) - min(sequence#) + 1
    as archive_value
  from v$log_history
  where (sysdate-first_time) < 1 union all select 'Volume de Archivelog (MBytes) nas ultimas 24 horas'      , round( sum(blocks*block_size)/1024/1024             / ( max(first_time) - min(first_time) ) )     as archive_value   from ( select max(blocks) as blocks, max(block_size) as block_size               , max(first_time) as first_time          from v$archived_log          where ARCHIVED = 'YES' and (sysdate-first_time) < 1          group by SEQUENCE# ) 
/ 
