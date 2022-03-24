--------------------------------------------------------------------  
select a.*
  from sys.all_source a
 where upper(a.text) like '%PROCEDURE%'
 order by a.owner, a.name;
--------------------------------------------------------------------  
select a.*
  from sys.all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%NUMTEL%' or
        upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%' or
        upper(a.text) like '%SUBSTR%')
 order by a.owner, a.name;
--------------------------------------------------------------------
select distinct a.owner, a.name, a.line
  from sys.all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%NUMTEL%' or
        upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%' or
        upper(a.text) like '%SUBSTR%')
 order by a.owner, a.name, a.line;
--------------------------------------------------------------------
select a.*
  from sys.all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%')
   and upper(a.name) in ('PA_CARREGA_INFOMKT',
                         'PA_CARREGA_SRF',
                         'PK_CARREGA_ACSP',
                         'PK_CARREGA_ALTOS_VALORES',
                         'PK_CARREGA_ESPECIALISTA',
                         'PK_CARREGA_LG_CONSULTA',
                         'PK_CARREGA_NEGAT',
                         'PK_CARREGA_SCPC',
                         'PK_CARREGA_SCPC_PJ',
                         'PK_CARREGA_SERASA',
                         'PK_CARREGA_T0MESA',
                         'PK_CARREGA_USE_FONE',
                         'PK_INTEGRA_EMITENTE_COMPLETO')
 order by a.name;
--------------------------------------------------------------------
select a.*
  from sys.all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%')
   and upper(a.name) in ('ACERTA_CONTROLE',
                         'CARGA_ORIGEM_ATRIBUTO',
                         'CARREGA_EMITENTES',
                         'CD_EMITENTE',
                         'CD_ENDERECO_EMITENTE',
                         'CD_TELEFONE_EMITENTE',
                         'CREDITO_EMITENTE_LIMITE',
                         'DEFERRED_CONSTRAINT',
                         'DELETE_TABLE',
                         'FC_IDENTIFICA_SEXO',
                         'INSERT_ATIV_PROF',
                         'MOSTRA_MAX',
                         'PA_CARREGA_INFOMKT',
                         'PA_CARREGA_SRF',
                         'PK_CARREGA_ACSP',
                         'PK_CARREGA_ALTOS_VALORES',
                         'PK_CARREGA_DATALISTAS',
                         'PK_CARREGA_ESPECIALISTA',
                         'PK_CARREGA_LG_CONSULTA',
                         'PK_CARREGA_NEGAT',
                         'PK_CARREGA_SCPC',
                         'PK_CARREGA_SCPC_PJ',
                         'PK_CARREGA_SERASA',
                         'PK_CARREGA_T0MESA',
                         'PK_CARREGA_USE_FONE',
                         'PK_ENDERECO',
                         'PK_INTEGRA_EMITENTE_COMPLETO',
                         'PK_LIMPA_SCPC_SERASA',
                         'PR_ACERTA_RESUMIDO',
                         'PR_ACERTO_DADOS_TL05_TL01',
                         'PR_ACERTO_ORIGEM_ATRIB_MMD',
                         'PR_ACERTO_REPLICA_EMICP',
                         'PR_ATUALIZA',
                         'PR_ATUALIZA_AU_INTEGRACAO',
                         'PR_ATUALIZA_DADOS_EMITENTE',
                         'PR_ATUALIZA_DADOS_FIXOS',
                         'PR_ATUALIZA_EMITENTE_NAZIDE',
                         'PR_ATUALIZA_MMD',
                         'PR_ATUALIZA_NEGAT',
                         'PR_ATUALIZA_ORIGEM_PESO',
                         'PR_ATUALIZA_RESUMIDO_DT_NASC',
                         'PR_ATUA_SEXO_CAD_EMITENTES',
                         'PR_CARGA_EMIT_RESUMIDO_DT_TEL',
                         'PR_COMBO_ATRIBUTO',
                         'PR_COMBO_ORIGEM',
                         'PR_CONS_REGISTROS_INTEGRADOS',
                         'PR_CONTADOR_CLASSE',
                         'PR_CONTAGEM_CIDADE',
                         'PR_CONTAGEM_DOCUMENTOS',
                         'PR_CORRIGE_ENDERECO_PAR',
                         'PR_CORRIGE_SEXO',
                         'PR_DADOS_EMITENTE',
                         'PR_GERA_ARQ_CIDADE',
                         'PR_INCLUI_EMI_ATRIBUTO',
                         'PR_INCLUSAO_PESO_LG_AUTO',
                         'PR_LISTA_DADOS_EMITENTE',
                         'PR_LISTA_TOTAIS_CAD_EMITENTE',
                         'PR_NEWDBASE_MAIO_2004_TRANS',
                         'PR_SCORE_FLEX',
                         'PR_SELECIONA_EMITENTES2',
                         'PR_SEPARA_ARQ_DATALISTA',
                         'PR_TOTAIS_CAD_EMITENTE',
                         'PR_TRUNCA_CONTROLE_EMITENTES',
                         'PR_TRUNCA_EMITENTE_ETIQUETA',
                         'PR_TRUNCA_TABELA',
                         'TRUNCATE_TABLE',
                         'VERSION',
                         'VW_EMITENTE',
                         'VW_EMITENTE_ENDERECO',
                         'VW_EMITENTE_RESUMIDO',
                         'VW_EMITENTE_TELEFONE')
 order by a.name;
--------------------------------------------------------------------
select 'alter ' ||
       decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type) || ' ' ||
       owner || '.' || object_name || ' compile ' ||
       decode(object_type, 'PACKAGE BODY', 'body') || ';'
  from dba_objects
 where status <> 'VALID'
   and owner = '&owner';
--------------------------------------------------------------------
select a.*
  from sys.all_source a
 where upper(a.text) like '%CD_PLANO%'
--   and a.name = 'PA_AUTORIZADOR_COMPRA'
 order by a.owner, a.name, a.line;
--------------------------------------------------------------------
select a.*
  from sys.all_source a
 where upper(a.text) like '%S5B.PA_AUTORIZADOR_COMPRA.CD_PLANO%'
--   and a.name = 'PA_AUTORIZADOR_COMPRA'
 order by a.owner, a.name, a.line;
--------------------------------------------------------------------
select a.*
  from sys.all_source a
 where upper(a.text) like '%VL_CACO%'
--   and a.name = ''
   and a.owner = 'S5B'
 order by a.owner, a.name, a.line;


