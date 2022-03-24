select distinct
       segment_name,
       segment_type,
       user,
       b.bytes,
       (case
         when length(a.initial_extent / 1024) = 3 then
          ((a.initial_extent / 1024) || ' KB')
         when length(a.initial_extent / 1024 / 1024) >= 3 then
          ((a.initial_extent / 1024 / 1024) || ' MB')
       end) initi,
       (case
         when length(a.next_extent / 1024) = 3 then
          ((a.next_extent / 1024) || ' KB')
         when length(a.next_extent / 1024 / 1024) >= 3 then
          ((a.next_extent / 1024 / 1024) || ' MB')
       end) nexte,
       a.last_analyzed
  from dba_tables a,
       dba_segments b
 where b.segment_name = a.table_name
   and b.segment_name not like 'BIN%'
   and b.segment_name not like 'DBG%'
   and b.segment_name not like 'PLSQL%'
   and b.segment_name not like 'TESTE%'
   and b.segment_name not like 'PLAN%'
--   and b.segment_name = nvl(upper('&NOME_DO_SEGMENTO'), a.table_name)
   and b.segment_type in ('TABLE', 'INDEX')
   and a.owner = upper(user)
 order by b.bytes desc;
