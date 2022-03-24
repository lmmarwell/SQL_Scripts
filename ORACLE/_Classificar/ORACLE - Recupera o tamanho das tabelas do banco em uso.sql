--------------------------------------------------------------------------------
-- 1 Byte = 8 Bit
-- 1 Kilobyte = 1024 Bytes
-- 1 Megabyte = 1024 * 1024 = 1048576 Bytes
-- 1 Gigabyte = 1024 * 1024 * 1024 = 1073741824 Bytes
--------------------------------------------------------------------------------
select substr(s.segment_name, 1, 20) table_name,
       substr(s.tablespace_name, 1, 20) tablespace_name,
       decode(s.extents,
              1,
              s.initial_extent,
              (s.initial_extent + (s.extents - 1) * s.next_extent)) /
       (1024 * 1024) allocated_mb,
       round((t.num_rows * t.avg_row_len / (1024 * 1024)), 2) required_mb,
       t.num_rows
  from dba_segments s, dba_tables t
 where s.owner = t.owner
   and s.segment_name = t.table_name
--   and t.num_rows > 0
   and t.table_name in ('COR_DOF',
                        'COR_DOF_BCK',
                        'COR_DOF_CTE',
                        'COR_DOF_CTE_BCK',
                        'COR_IDF',
                        'COR_IDF_BCK',
                        'COR_IDF_CTE',
                        'COR_IDF_CTE_BCK')
   and t.owner = 'FISC33'
 order by s.segment_name;
-------------------------------------------------------------------------------- 
select distinct
       cfk.table_name table_name_fk,
       ccf.constraint_name,
       cfk.constraint_type,
       cpk.table_name table_name_pk
  from user_constraints  cfk,
       user_cons_columns ccf,
       user_constraints  cpk,
       user_cons_columns ccp
 where ccp.position          = ccf.position
   and ccp.owner             = cpk.owner
   and ccp.constraint_name   = cpk.constraint_name
   and ccp.table_name        = cpk.table_name
   and cpk.constraint_name   = cfk.r_constraint_name
   and ccf.constraint_name   = cfk.constraint_name
   and ccf.table_name        = cfk.table_name
   and ccf.owner             = cfk.owner
   and cfk.constraint_type   = 'R'
   and (cfk.table_name       = 'COR_IDF_MSG' or
        cpk.table_name       = 'COR_IDF_MSG')
 order by cfk.table_name,
          ccf.constraint_name,
          cfk.constraint_type,
          cpk.table_name
--------------------------------------------------------------------------------
select substr(s.segment_name, 1, 20) table_name,
       substr(s.tablespace_name, 1, 20) tablespace_name,
       decode(s.extents,
              1,
              s.initial_extent,
              (s.initial_extent + (s.extents - 1) * s.next_extent)) /
       (1024 * 1024) allocated_mb,
       round((t.num_rows * t.avg_row_len / (1024 * 1024)), 2) required_mb,
       t.num_rows
  from dba_segments s, dba_tables t
 where s.owner = t.owner
   and s.segment_name = t.table_name
--   and t.num_rows > 0
   and t.table_name in ('COR_DOF',
                        'COR_DESFAZIMENTO_DOF',
                        'COR_DOF_APROVACAO',
                        'COR_DOF_ASSOCIADO',
                        'COR_DOF_CCUS',
                        'COR_DOF_GRI',
                        'COR_DOF_IRREGULARIDADE',
                        'COR_DOF_MSG',
                        'COR_DOF_PARCELA',
                        'COR_DOF_PROCESSO',
                        'COR_DOF_RECEBIMENTO',
                        'COR_DOF_VOLUME_CARGA',
                        'COR_ECF_ASSOCIADO',
                        'COR_EXTENSAO_FRETE',
                        'COR_IDF',
                        'COR_IMP_EXP',
                        'COR_LEITURA_Z',
                        'EMI_REIMP_DOC',
                        'EMI_SNF_DOF',
                        'FIS_SPED_LIMP_DOF',
                        'COR_DOFIDF_CCUS',
                        'COR_IDF_CCUS',
                        'COR_IDF_LOTE_MED',
                        'COR_IDF_MSG',
                        'COR_IDF_RECUP_ST',
                        'COR_PED_X_IDF',
                        'LALUR_ARQUIVO_DOF_IDF',
                        'SAP_CIAP_IDF_OUTPUT',
                        'COR_DOFASSOC_REMESSA_EXPORTADA',
                        'COR_PEDIDF_ESTOQUE',
                        'LALUR_ARQUIVO_DOF_PARC',
                        'COR_DOF_CTE',
                        'COR_IDF_CTE')
   and t.owner = 'FISC33'
 order by s.segment_name;

--------------------------------------------------------------------------------
select ext.segment_name table_name,
       sum(ext.bytes) / (1024 * 1024) table_size_meg,
       sum(ext.blocks) blocks
  from user_extents ext
 where ext.segment_type = 'TABLE'
--   and ext.segment_name = 'SYN_PRCGER_IMPRESSAO'
group by ext.segment_name
order by ext.segment_name;
--------------------------------------------------------------------------------
select table_name,
       ((num_rows * avg_row_len) / (1024 * 1024)) table_size_meg,
       num_rows
  from user_tables
-- where table_name = 'SYN_PRCGER_IMPRESSAO'
 order by table_name;
--------------------------------------------------------------------------------
select substr(s.segment_name, 1, 20) table_name,
       substr(s.tablespace_name, 1, 20) tablespace_name,
       decode(s.extents,
                    1,
                    s.initial_extent,
                    (s.initial_extent + (s.extents - 1) * s.next_extent)) /
             (1024 * 1024) allocated_mb,
       round((t.num_rows * t.avg_row_len / (1024 * 1024)), 2) required_mb,
       t.num_rows
  from dba_segments s, dba_tables t
 where s.owner = t.owner
   and s.segment_name = t.table_name
--   and t.table_name = 'SYN_PRCGER_IMPRESSAO'
--   and t.table_name in ()
   and t.owner = 'FISC33'
 order by s.segment_name;
--------------------------------------------------------------------------------
select owner,
       segment_type,     
       sum(bytes) / (1024 * 1024) size_mb,
       sum(blocks) blocks
  from sys.dba_segments
 where segment_type not like '%PARTITION%'
 group by owner,
          segment_type
 order by owner,
          segment_type
--------------------------------------------------------------------------------
select distinct
       a.table_name,
       b.segment_name,
       b.bytes,
       (b.bytes/1024/1024/1024) size_gb,
       (case
         when length(a.initial_extent / 1024) = 3 then
          ((a.initial_extent / 1024))
         when length(a.initial_extent / (1024 * 1024)) >= 3 then
          ((a.initial_extent / (1024 * 1024)))
       end) initi_mb,
       (case
         when length(a.next_extent / 1024) = 3 then
          ((a.next_extent / 1024))
         when length(a.next_extent / (1024 * 1024)) >= 3 then
          ((a.next_extent / (1024 * 1024)))
       end) nexte_mb,
       a.last_analyzed
  from user_indexes a,
       user_segments b
 where b.segment_name = a.index_name
   and a.index_name not in (select constraint_name
                              from user_constraints
                             where constraint_type in ('C', 'P', 'U', 'R', 'V'))
--   and b.segment_type in ('INDEX')
--   and b.segment_name = 'ACUM_IMP_PARCS_FK_I'
--   and a.table_name = 'COR_DOF'
 order by --b.bytes desc,
          --a.table_name,
          b.segment_name;
--------------------------------------------------------------------------------
select seg.segment_type,
       seg.tablespace_name,
       seg.segment_name,
       (sum(seg.bytes) / 1024 / 1024 / 1024) size_gb
  from sys.user_segments seg
 where seg.segment_name not like 'BIN%'
   and segment_type not like '%PARTITION%'
--   and segment_type = 'TABLE'
--   and seg.segment_name in ('COR_REGISTRO_PESSOA_UF')
--   and seg.segment_name like '%BON_LOG_%'
 group by seg.segment_type,
          seg.tablespace_name,
          seg.segment_name
 order by seg.segment_type,
          seg.tablespace_name,
          seg.segment_name;
--------------------------------------------------------------------------------
select seg.segment_type,
       seg.tablespace_name,
       seg.segment_name,
       (sum(seg.bytes) / 1024 / 1024 / 1024) size_gb
  from sys.user_segments seg
 where seg.segment_name not like 'BIN%'
   and segment_type not like '%PARTITION%'
--   and segment_type = 'TABLE'
--   and seg.segment_name in ('COR_REGISTRO_PESSOA_UF')
--   and seg.segment_name like '%AGENDA_CCRI_FK_I%'
 group by seg.segment_type,
          seg.tablespace_name,
          seg.segment_name
 order by seg.segment_type,
          seg.tablespace_name,
          seg.segment_name;
--------------------------------------------------------------------------------          
select seg.tablespace_name,
       sum(decode(seg.segment_type, 'TABLE', (seg.bytes / 1024 / 1024 / 1024), 0)) table_size_gb,
       sum(decode(seg.segment_type, 'INDEX', (seg.bytes / 1024 / 1024 / 1024), 0)) index_size_gb
  from sys.user_segments seg
 where seg.segment_name not like 'BIN%'
   and segment_type not like '%PARTITION%'
 group by seg.tablespace_name
 order by seg.tablespace_name;
--------------------------------------------------------------------------------
