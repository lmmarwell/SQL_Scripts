select t.owner,
       t.table_name,
       'select ' || chr(039) || t.owner || '.' || t.table_name || chr(039) || ' tabela, count(1) total_registro' ||
        ' from ' || lower(t.owner || '.' || t.table_name) || ' union all' script
  from sys.all_tables t
 where (t.table_name like 'TB\_%' escape '\' or
        t.table_name like 'TA\_%' escape '\' or
        t.table_name like 'RE\_%' escape '\')
   and t.owner = 'SANFOM'
order by 1, 2;
--------------------------------------------------------------------------------
select 'SANFOM.RE_ALIQUOTA_TIPO_ALIQUOTA' tabela, count(1) total_registro from sanfom.re_aliquota_tipo_aliquota union all
select 'SANFOM.RE_ANO_CHAMADA_PUBLICA_PROJ' tabela, count(1) total_registro from sanfom.re_ano_chamada_publica_proj union all
select 'SANFOM.RE_BOLETO_RECOLHIMENTO' tabela, count(1) total_registro from sanfom.re_boleto_recolhimento union all
select 'SANFOM.RE_CHAMADA_MODELO_CONTRATO' tabela, count(1) total_registro from sanfom.re_chamada_modelo_contrato union all
select 'SANFOM.RE_CONFIG_CHAMADA_MODALIDADE' tabela, count(1) total_registro from sanfom.re_config_chamada_modalidade union all
select 'SANFOM.RE_CONTRATO_PROJETO' tabela, count(1) total_registro from sanfom.re_contrato_projeto union all
select 'SANFOM.RE_CUMPR_OBRIGACAO_DOCUMENTO' tabela, count(1) total_registro from sanfom.re_cumpr_obrigacao_documento union all
select 'SANFOM.RE_DOCUMENTO_SOLICITACAO' tabela, count(1) total_registro from sanfom.re_documento_solicitacao union all
select 'SANFOM.RE_INTERVENIENTE_CONTRATO' tabela, count(1) total_registro from sanfom.re_interveniente_contrato union all
select 'SANFOM.RE_MOD_CONTRATO_PARAM_CONTRATO' tabela, count(1) total_registro from sanfom.re_mod_contrato_param_contrato union all
select 'SANFOM.RE_MODELO_OBRIGACAO_CONTRATUAL' tabela, count(1) total_registro from sanfom.re_modelo_obrigacao_contratual union all
select 'SANFOM.RE_PARAMETRO_FAIXA' tabela, count(1) total_registro from sanfom.re_parametro_faixa union all
select 'SANFOM.RE_PROPOSTA_OBJ_FINANCIAVEL' tabela, count(1) total_registro from sanfom.re_proposta_obj_financiavel union all
select 'SANFOM.RE_VINCULA_CONTA' tabela, count(1) total_registro from sanfom.re_vincula_conta union all
select 'SANFOM.TA_CONFIG_PERIODO_DESPESA' tabela, count(1) total_registro from sanfom.ta_config_periodo_despesa union all
select 'SANFOM.TA_ENTIDADE_EXTERNA' tabela, count(1) total_registro from sanfom.ta_entidade_externa union all
select 'SANFOM.TA_MARCO_CONTROLE' tabela, count(1) total_registro from sanfom.ta_marco_controle union all
select 'SANFOM.TA_MODALIDADE' tabela, count(1) total_registro from sanfom.ta_modalidade union all
select 'SANFOM.TA_MODALIDADE_CHAMADA_PUBLICA' tabela, count(1) total_registro from sanfom.ta_modalidade_chamada_publica union all
select 'SANFOM.TA_MODALIDADE_INCENTIVO' tabela, count(1) total_registro from sanfom.ta_modalidade_incentivo union all
select 'SANFOM.TA_OBRA_INTELECTUAL' tabela, count(1) total_registro from sanfom.ta_obra_intelectual union all
select 'SANFOM.TA_SITUACAO_CHAMADA_PUBLICA' tabela, count(1) total_registro from sanfom.ta_situacao_chamada_publica union all
select 'SANFOM.TA_SITUACAO_CONTRATO' tabela, count(1) total_registro from sanfom.ta_situacao_contrato union all
select 'SANFOM.TA_SITUACAO_MODELO' tabela, count(1) total_registro from sanfom.ta_situacao_modelo union all
select 'SANFOM.TA_SITUACAO_PROPOSTA' tabela, count(1) total_registro from sanfom.ta_situacao_proposta union all
select 'SANFOM.TA_SITUACAO_UTILIZACAO' tabela, count(1) total_registro from sanfom.ta_situacao_utilizacao union all
select 'SANFOM.TA_SUPORTE_CAPTACAO' tabela, count(1) total_registro from sanfom.ta_suporte_captacao union all
select 'SANFOM.TA_SUPORTE_SIST_DEPOSITO_LEGAL' tabela, count(1) total_registro from sanfom.ta_suporte_sist_deposito_legal union all
select 'SANFOM.TA_TIPO_ALIQUOTA' tabela, count(1) total_registro from sanfom.ta_tipo_aliquota union all
select 'SANFOM.TA_TIPO_CHAMADA_PUBLICA' tabela, count(1) total_registro from sanfom.ta_tipo_chamada_publica union all
select 'SANFOM.TA_TIPO_EMPRESA' tabela, count(1) total_registro from sanfom.ta_tipo_empresa union all
select 'SANFOM.TA_TIPO_OBRA_DERIVADA' tabela, count(1) total_registro from sanfom.ta_tipo_obra_derivada union all
select 'SANFOM.TA_TIPO_OBRIGACAO_RELATORIO' tabela, count(1) total_registro from sanfom.ta_tipo_obrigacao_relatorio union all
select 'SANFOM.TA_TIPO_PROJETO' tabela, count(1) total_registro from sanfom.ta_tipo_projeto union all
select 'SANFOM.TA_TIPO_PROPOSTA' tabela, count(1) total_registro from sanfom.ta_tipo_proposta union all
select 'SANFOM.TA_TIPO_SITUACAO_OBRIGACAO' tabela, count(1) total_registro from sanfom.ta_tipo_situacao_obrigacao union all
select 'SANFOM.TB_ADITAMENTO' tabela, count(1) total_registro from sanfom.tb_aditamento union all
select 'SANFOM.TB_ALIQUOTA' tabela, count(1) total_registro from sanfom.tb_aliquota union all
select 'SANFOM.TB_ALOCA_RECURSO' tabela, count(1) total_registro from sanfom.tb_aloca_recurso union all
select 'SANFOM.TB_ANO_TIPO_CHAMADA_PUBLICA' tabela, count(1) total_registro from sanfom.tb_ano_tipo_chamada_publica union all
select 'SANFOM.TB_BOLETO_EMITIDO' tabela, count(1) total_registro from sanfom.tb_boleto_emitido union all
select 'SANFOM.TB_CONFIG_CHAMADA_CONTRATACAO' tabela, count(1) total_registro from sanfom.tb_config_chamada_contratacao union all
select 'SANFOM.TB_CONFIG_CHAMADA_PUBLICA' tabela, count(1) total_registro from sanfom.tb_config_chamada_publica union all
select 'SANFOM.TB_CONFIG_PROJETO_CHAMADA' tabela, count(1) total_registro from sanfom.tb_config_projeto_chamada union all
select 'SANFOM.TB_CONTA_RECOLHIMENTO' tabela, count(1) total_registro from sanfom.tb_conta_recolhimento union all
select 'SANFOM.TB_CONTRATO_FSA' tabela, count(1) total_registro from sanfom.tb_contrato_fsa union all
select 'SANFOM.TB_CUMPRIMENTO_OBRIGACAO' tabela, count(1) total_registro from sanfom.tb_cumprimento_obrigacao union all
select 'SANFOM.TB_DESTINACAO_SALA_EXIBICAO' tabela, count(1) total_registro from sanfom.tb_destinacao_sala_exibicao union all
select 'SANFOM.TB_DESTINACAO_TV' tabela, count(1) total_registro from sanfom.tb_destinacao_tv union all
select 'SANFOM.TB_DOCUMENTO_RECOLHIMENTO' tabela, count(1) total_registro from sanfom.tb_documento_recolhimento union all
select 'SANFOM.TB_FAIXA_PROJETO' tabela, count(1) total_registro from sanfom.tb_faixa_projeto union all
select 'SANFOM.TB_FORMULARIO' tabela, count(1) total_registro from sanfom.tb_formulario union all
select 'SANFOM.TB_LIBERACAO_RECURSO' tabela, count(1) total_registro from sanfom.tb_liberacao_recurso union all
select 'SANFOM.TB_METODO_ESTATISTICO' tabela, count(1) total_registro from sanfom.tb_metodo_estatistico union all
select 'SANFOM.TB_MODELO_CONTRATO' tabela, count(1) total_registro from sanfom.tb_modelo_contrato union all
select 'SANFOM.TB_MODELO_RETORNO_FINANCEIRO' tabela, count(1) total_registro from sanfom.tb_modelo_retorno_financeiro union all
select 'SANFOM.TB_OBJETO_FINANCIAVEL' tabela, count(1) total_registro from sanfom.tb_objeto_financiavel union all
select 'SANFOM.TB_OBRIGACAO_CONTRATUAL' tabela, count(1) total_registro from sanfom.tb_obrigacao_contratual union all
select 'SANFOM.TB_PARAMETRO_CALC_CARAC_OBRA' tabela, count(1) total_registro from sanfom.tb_parametro_calc_carac_obra union all
select 'SANFOM.TB_PARAMETRO_COMERCIALIZACAO' tabela, count(1) total_registro from sanfom.tb_parametro_comercializacao union all
select 'SANFOM.TB_PARAMETRO_CONTRATO' tabela, count(1) total_registro from sanfom.tb_parametro_contrato union all
select 'SANFOM.TB_PARAMETRO_FAIXA' tabela, count(1) total_registro from sanfom.tb_parametro_faixa union all
select 'SANFOM.TB_PARAMETRO_ITEM' tabela, count(1) total_registro from sanfom.tb_parametro_item union all
select 'SANFOM.TB_PENALIDADE_CONTRATUAL' tabela, count(1) total_registro from sanfom.tb_penalidade_contratual union all
select 'SANFOM.TB_PROJETO_FSA' tabela, count(1) total_registro from sanfom.tb_projeto_fsa union all
select 'SANFOM.TB_PROPOSTA' tabela, count(1) total_registro from sanfom.tb_proposta union all
select 'SANFOM.TB_RELATORIO_COMERCIALIZACAO' tabela, count(1) total_registro from sanfom.tb_relatorio_comercializacao union all
select 'SANFOM.TB_RESUMO_ORCAMENTO' tabela, count(1) total_registro from sanfom.tb_resumo_orcamento union all
select 'SANFOM.TB_RETORNO_FINANCEIRO_FSA' tabela, count(1) total_registro from sanfom.tb_retorno_financeiro_fsa union all
select 'SANFOM.TB_SANCAO_CONTRATUAL' tabela, count(1) total_registro from sanfom.tb_sancao_contratual union all
select 'SANFOM.TB_SOLICITACAO_CONTA' tabela, count(1) total_registro from sanfom.tb_solicitacao_conta union all
select 'SANFOM.TB_TIPO_PROJETO' tabela, count(1) total_registro from sanfom.tb_tipo_projeto union all
select 'SANFOM.TB_TRANSFERE_RECURSO' tabela, count(1) total_registro from sanfom.tb_transfere_recurso;
--------------------------------------------------------------------------------