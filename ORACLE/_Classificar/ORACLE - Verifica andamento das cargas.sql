/**/ --------------------------------------------------------------------------------------------------
/**  VERIFICA O ANDAMENTO DAS CARGAS NO SYNCHRO                                                      */
/**/ --------------------------------------------------------------------------------------------------
/**/    SELECT '1' ID,'INTERMEDIÁRIA' AS TABELA, 
/**/           TO_CHAR(COUNT(1),'9G999G999') || ' Registros' TOTAL, 
/**/           MSG_CRITICA 
/**/      FROM SAP_ITF_SALDO_MENSAL_IN 
/**/     group by MSG_CRITICA
/**/    UNION
/**/    SELECT '2','DEFINITIVA', 
/**/           TO_CHAR(COUNT(1),'9G999G999') || ' Registros', '******************' 
/**/      FROM IN_SALDO_MENSAL
/**/ --------------------------------------------------------------------------------------------------