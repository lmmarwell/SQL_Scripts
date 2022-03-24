
/***************************************************************/
/* VERIFICA O TAMANHO DA TABLESPACE QUE ESTÁ SENDO ATUALIZADA  */
/* DURANTE APLICAÇÃO DOS SCRIPTS OTIMIZADOS DOS SERVICES PACKS */
/***************************************************************/
/* INICIO */
      -- Quantidade de registros da tabela que está sendo atualizada
      SELECT 1, 'QTDE. ' || SUBSTR(DBG.CODIGO,6, LENGTH(DBG.CODIGO)-5), 
             (SELECT TO_CHAR(NUM_ROWS,'999G999G999', 'nls_numeric_characters='',.''') 
                FROM USER_TABLES 
               WHERE TABLE_NAME = SUBSTR(DBG.CODIGO,6, LENGTH(DBG.CODIGO)-5))
        FROM SYN_DEBUG DBG
       WHERE DBG_ID = (SELECT MAX(DBG_ID) FROM SYN_DEBUG)
      --  
      UNION
      -- Quantidade de regisros gravados
      SELECT 2, 'QTDE. GRAVADOS', TO_CHAR(LINHA,'999G999G999', 'nls_numeric_characters='',.''') 
        FROM SYN_DEBUG 
       WHERE DBG_ID = (SELECT MAX(DBG_ID) FROM SYN_DEBUG )
      -- 
      UNION      
      -- Espaço livre na Tablesspace da tabela que está sendo atualizada
      SELECT 3, TABLESPACE_NAME || ' Espaço livre', TO_CHAR(SUM(BYTES)/1024/1024) /*,'999G999G999', 'nls_numeric_characters='',.''') */ || ' Mb' Mbytes
        FROM DBA_FREE_SPACE
       WHERE TABLESPACE_NAME = (SELECT TABLESPACE_NAME 
                                  FROM USER_TABLES 
                                 WHERE TABLE_NAME = (SELECT SUBSTR(CODIGO,6, LENGTH(CODIGO)-5) 
                                                       FROM SYN_DEBUG
                                                      WHERE DBG_ID = (SELECT MAX(DBG_ID) FROM SYN_DEBUG)))
       GROUP BY TABLESPACE_NAME
      --
      UNION
      -- Espaço livre na Tablespace TEMP
      SELECT 4, TABLESPACE_NAME || ' Espaço livre', TO_CHAR(SUM(BYTES)/1024/1024) /*,'999G999G999', 'nls_numeric_characters='',.''') */ || ' Mb' Mbytes
        FROM DBA_FREE_SPACE
       WHERE TABLESPACE_NAME = 'TEMP'
       GROUP BY TABLESPACE_NAME      
/* FIM */
