select distinct
			 seg.segment_name,
			 seg.segment_type,
			 user,
			 seg.bytes,
			 tab.num_rows,
			 (
			  case
			 	  when length(tab.initial_extent / 1024) = 3         then ((tab.initial_extent / 1024) || ' KB')
				  when length(tab.initial_extent / 1024 / 1024) > 3 then ((tab.initial_extent / 1024 / 1024) || ' MB')
			  end
			 ) init,
			 (
			  case
				  when length(tab.next_extent / 1024) = 3         then ((tab.next_extent / 1024) || ' KB')
				  when length(tab.next_extent / 1024 / 1024) > 3 then ((tab.next_extent / 1024 / 1024) || ' MB')
			  end
			 ) next,
			 to_date(tab.last_analyzed, 'dd/mm/yyyy hh24:mi:ss') last_analyzed,
			 ts.segment_space_management
  from dba_tables   tab,
			 dba_segments seg,
			 dba_tablespaces ts
 where ts.tablespace_name =  seg.tablespace_name
--	 and tab.last_analyzed  >= to_date('04/02/2010', 'dd/mm/yyyy') 
	 and tab.table_name     =  seg.segment_name
	 and seg.segment_name not like 'BIN%'
	 and seg.segment_name not like 'DBG%'
	 and seg.segment_name not like 'PLSQL%'
	 and seg.segment_name not like 'TESTE%'
	 and seg.segment_name not like 'PLAN%'
--   and seg.segment_type in ('TABLE', 'INDEX')
--   and seg.segment_name like 'TMPP%'
 order by user,
			    seg.segment_type,
			    seg.segment_name;
--   and seg.segment_name = :p_tabname
--   and tab.owner = upper(user)
--	 and seg.segment_name like 'BON%'
--	 and seg.segment_name like 'TMPPRC%'
--	 and seg.segment_name = nvl(upper(:p_tabname),tab.table_name)
--	 and seg.segment_name in ('SYN_PRCGER_IMPRESSAO',
--	                          'TMPPRC_531175')
--	 and seg.segment_name in ('SYN_HTML_IMPRESSAO',
--	                          'SYN_HTML_VALOR_VARIAVEL',
--													  'SYN_JOB_CADASTRO',
--													  'SYN_JOB_EXECUTADO',
--													  'SYN_JOB_PARAMETRO',
--													  'SYN_PRCGER_CABECALHO',
--													  'SYN_PRCGER_IMPRESSAO',
--													  'SYN_PRCGER_PARAMETRO',
--													  'SYN_PRC_GERADO')
--------------------------------------------------------------------------------
--select OBJECT_NAME
--  from SYS.DBA_OBJECTS
-- where OBJECT_NAME like'TMPPRC%'
--   and OBJECT_TYPE = 'TABLE'
-- order by OBJECT_NAME
--------------------------------------------------------------------------------
-- drop table TMPPRC_00000000;
-- drop table TMPPRC_531015;
-- drop table TMPPRC_531035;
-- drop table TMPPRC_531055;
-- drop table TMPPRC_531075;
-- drop table TMPPRC_531097;
-- drop table TMPPRC_531115;
-- drop table TMPPRC_531135;
-- drop table TMPPRC_531155;
-- drop table TMPPRC_531157;
-- drop table TMPPRC_531175;
--------------------------------------------------------------------------------
