select tab.owner,
       seg.segment_type,
       seg.segment_name,
       (sum(seg.blocks) * 2048 / 1024) Blocos_Kb,
       12 mese_retencao,
       sum(distinct tab.data_length) tam_linha,
       0 num_reg_inic,
       1000000 num_reg_anual,
       (sum(tab.data_length) * 1000000) cres_anual
  from sys.dba_segments seg,
       sys.dba_tab_cols tab  
 where segment_name = table_name
   and tab.owner = 'FISC33'
   and seg.segment_name in ('COR_DOF_GRI',
                            'FIS_SPED_LIMP_DOF',
                            'SYNITF_AJUSTE_UF',
                            'SYNITF_COMB_BOMBA',
                            'SYNITF_DOF_PROCESSO',
                            'SYNITF_ECF_ASSOCIADO',
                            'SYNITF_OPERACAO_CARTAO',
                            'COR_IDF_LOTE_MED')
 group by tab.owner,
          seg.segment_type,
          seg.segment_name
 order by tab.owner,
          seg.segment_type,
          seg.segment_name;