select distinct 
       b.segment_name,
       a.last_analyzed,
       b.segment_type,
       user,
       b.bytes,
       a.initial_extent,
       a.next_extent,
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
  from user_tables a, user_segments b
 where b.segment_name = a.table_name
--   and b.segment_name not like 'BIN%'
--   and b.segment_name not like 'DBG%'
--   and b.segment_name not like 'PLSQL%'
--   and b.segment_name not like 'TESTE%'
--   and b.segment_name not like 'PLAN%'
--   and b.segment_name = nvl(upper('&NOME_DO_SEGMENTO'), a.table_name)
   and b.segment_name in ('CONTA_DIGITAL_TXT_BLOB',
                          'TB_BILL_IMAGE_XLS_1',
                          'TB_BILL_IMAGE_XLS_2',
                          'TB_BILL_IMAGE_XLS_3',
                          'TB_BILL_IMAGE_XLS_4',
                          'TB_BILL_IMAGE_XLS_5',
                          'TB_BILL_IMAGE_XLS_6',
                          'TB_FATS_NAO_PROC',
                          'TB_PROC_CARGA_XLS')
   and b.segment_type in ('TABLE', 'INDEX')
--   and a.owner = upper(user)
 order by b.bytes desc;
