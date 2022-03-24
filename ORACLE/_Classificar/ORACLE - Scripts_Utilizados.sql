 select remetente_pfj_codigo,dt_fato_gerador,dh_emissao, rowid from cor_dof_cte 
  where informante_est_codigo is null
  AND   informante_est_codigo <> cor_est_principal( remetente_pfj_codigo   , NVL( dt_fato_gerador, dh_emissao));

  
  SELECT COUNT(1) FROM COR_DOF_CTE   where informante_est_codigo is null
  
  SELECT  informante_est_codigo,  cor_est_principal( remetente_pfj_codigo   , NVL( dt_fato_gerador, dh_emissao)) FROM COR_DOF_CTE
  
  SELECT informante_est_codigo FROM COR_DOF_CTE 
  WHERE informante_est_codigo <> cor_est_principal( remetente_pfj_codigo   , NVL( dt_fato_gerador, dh_emissao))
  
  
  SELECT * FROM COR_INICIALIZACAO WHERE 
  
SELECT * FROM USER_TABLES WHERE TABLE_NAME LIKE '%COR_DOF_CTE%'

SELECT SYSDATE, SID, BLOCK_GETS, CONSISTENT_GETS, 
       PHYSICAL_READS, BLOCK_CHANGES, CONSISTENT_CHANGES 
FROM V$SESS_IO WHERE SID=134

SELECT SYSDATE FROM DUAL

select IND_INCIDENCIA_INSS_RET from cor_dof WHERE IND_INCIDENCIA_INSS_RET IS NULL= 'S'


select * from user_col_comments where table_name = 'COR_DOF' AND COLUMN_NAME ='MUN_PRES_SERVICO'

select TO_CHAR(num_rows,'99,999,999,999') from user_tables where table_name IN ('COR_DOF','COR_DOF_CTE')



SELECT SYSDATE, SUBSTR(SQL_TEXT, 1, 30), EXECUTIONS 
FROM V$SQL WHERE SQL_TEXT LIKE '%UPDATE%'


--Verificando as sessions 
select SID, 
       STATUS, 
       SCHEMANAME, 
       OSUSER, 
       MACHINE, 
       PROGRAM, 
       MODULE, 
       ACTION, 
       LOGON_TIME 
  From v$session where username = 'FISC33' 

SELECT SUBSTR(DATA,1,4), COUNT(COL) FROM INTELIG_CONTABILIZA GROUP BY SUBSTR(DATA,1,4)


SELECT SUBSTR(DATA,1,4), TO_CHAR(COUNT(COL)*100000,'99G999G999') FROM INTELIG_CONTABILIZA GROUP BY SUBSTR(DATA,1,4)

select * from user_objects where object_name = UPPER('syn_gera_livro')

       (SELECT SUBSTR(DATA,1,4), TO_CHAR(SUM(COL),'99G999G999') 
       FROM INTELIG_CONTABILIZA 
       WHERE DATA LIKE 'FORA%'  
       GROUP BY SUBSTR(DATA,1,4))
       UNION ALL 
       (SELECT SUBSTR(DATA,1,6), TO_CHAR(COUNT(COL)*30000,'99G999G999') 
       FROM INTELIG_CONTABILIZA 
       WHERE DATA LIKE  'DENTRO%'  
       GROUP BY SUBSTR(DATA,1,6))
       
       
       UNION ALL
       (SELECT 'DENTRO PERFORMANCE', SUBSTR(A.DATA,8,8), SUBSTR(B.DATA,8,8)
       FROM INTELIG_CONTABILIZA A, INTELIG_CONTABILIZA B
       WHERE A.COL IN (SELECT MAX(COL) 
                    FROM INTELIG_CONTABILIZA 
                    WHERE DATA LIKE  'DENTRO%')
       AND   B.COL IN (SELECT MAX(COL)-1 
                    FROM INTELIG_CONTABILIZA 
                    WHERE DATA LIKE  'DENTRO%'))
       

ALTER PROCEDURE syn_gera_livro COMPILE  

SELECT * FROM USER_OBJECTS WHERE STATUS = 'INVALID'

                    
SELECT to_char(COL*30000,'99G999G999') , DATA FROM INTELIG_CONTABILIZA WHERE DATA LIKE 'DENTRO%'
--aproximadamente 420.000 gravações/h

244	  7,320,000	DENTRO 11:16:01 
245	  7,350,000	DENTRO 11:27:11 - 00:11:10
246	  7,380,000	DENTRO 11:41:05 - 00:13:

SELECT * FROM IN_CODIGO WHERE NUMERO=20 AND ID=2010

SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = 'IN_DOF'
SELECT * FROM USER_COL_COMMENTS WHERE COLUMN_NAME LIKE '%STE%' AND COLUMN_NAME NOT LIKE '%AJUSTE%'
  SELECT COUNT(1) BULK FROM IN_DOF
  
SELECT DISTINCT ICOD_ID_STE  FROM IN_IDF A WHERE ICOD_ID_STE IS NOT NULL
SELECT NUMERO, A.* FROM IN_DOF A   WHERE ID = 475170
  
select SQL_TEXT, EXECUTIONS, SYSDATE from v$sql where upper(sql_text) like '%UPDATE COR_IDF%'

537517
547709




INSERT INTO INTELIG_CONTABILIZA VALUES (33, TO_CHAR(SYSDATE,'HH24:MI:SS'))


select SQL_TEXT, EXECUTIONS, SYSDATE from v$sql where upper(sql_text) like '%INTELIG%'

select * from user_triggers where table_name = 'COR_IDF'





select 138 * 30000 from dual
select 60000000/1830000 from dual
create table AMTEL_TMP
(
  INFORMANTE_EST_CODIGO   VARCHAR2(20) not null,
  SERIE_SUBSERIE          VARCHAR2(6) not null,
  SIS_CODIGO              VARCHAR2(6) not null,
  NUMERO                  VARCHAR2(12),
  DT_FATO_GERADOR_IMPOSTO DATE,
  DIF                     INTEGER
)

19:48:46 3.828.155
19:49:46 3.844.459

20:39:06



             UPDATE cor_idf SET
             IND_INCIDENCIA_PIS_RET    = Nvl( ind_incidencia_pis_ret, 'N' )
            ,IND_INCIDENCIA_COFINS_RET = Nvl( ind_incidencia_cofins_ret, 'N' )
            ,IND_INCIDENCIA_CSLL_RET   = Nvl( ind_incidencia_csll_ret, 'N' )
            ,IND_INCIDENCIA_INSS_RET   = Nvl( ind_incidencia_inss_ret, 'N' )
            ,ALIQ_INSS_RET             = Nvl( aliq_inss_ret, 0 )
            ,VL_BASE_INSS_RET          = Nvl( vl_base_inss_ret, 0 )
            ,VL_INSS_RET               = Nvl( vl_inss_ret, 0 )
            ,VL_OUTROS_ABAT            = Nvl( vl_outros_abat, 0 )
            ,PERC_OUTROS_ABAT          = Nvl( perc_outros_abat, 0 )
            ,IND_VL_TRIB_RET_NO_PRECO  = Nvl( ind_vl_trib_ret_no_preco, 'N' )
            ,codigo_iss_municipio      = Nvl( codigo_iss_municipio, mcodigo_iss )
        Where Rowid = midf.Row_Id;
        
        SELECT COUNT(*) FROM COR_IDF WHERE CODIGO_ISS_MUNICIPIO IS NULL


select count(1) bulk from cor_idf where IND_VL_TRIB_RET_NO_PRECO IS NOT NULL        

SELECT 4140000 + 56417825 FROM DUAL 
60557825
60569437
SELECT NUM_ROWS FROM USER_TABLES WHERE TABLE_NAME = 'COR_IDF'

SELECT SYSDATE, SID, BLOCK_GETS, CONSISTENT_GETS, 
       PHYSICAL_READS, BLOCK_CHANGES, CONSISTENT_CHANGES 
FROM V$SESS_IO WHERE SID=134

SELECT * FROM V$SESS_IO WHERE SID=134

select * from v$process

*********************************************************************************************
*********************************************************************************************
*********************************************************************************************
*********************************************************************************************
*********************************************************************************************

       (SELECT SUBSTR(DATA,1,4), TO_CHAR(SUM(COL),'99G999G999') 
       FROM INTELIG_CONTABILIZA 
       WHERE DATA LIKE 'FORA%'  
       GROUP BY SUBSTR(DATA,1,4))
       UNION ALL 
       (SELECT SUBSTR(DATA,1,6), TO_CHAR(COUNT(COL)*30000,'99G999G999') 
       FROM INTELIG_CONTABILIZA 
       WHERE DATA LIKE  'DENTRO%'  
       GROUP BY SUBSTR(DATA,1,6))
       
       select sysdate + to_date(18-01-2009,'DD-MM-YYYY') from intelig_contabiliza
       
       SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') - to_DATE('2009-03-18','YYYY-MM-DD') FROM DUAL
       
       SELECT TO_DATE(SYSDATE,'10:00:00','HH24:MI:SS')   FROM DUAL
       
       SELECT COL, TO_CHAR(COL*30000,'99G999G999'), DATA, '16/03/09' AS "DATA" FROM INTELIG_CONTABILIZA WHERE COL = (
       SELECT MIN(COL) FROM INTELIG_CONTABILIZA WHERE DATA LIKE ('DENTRO%'))
       GROUP BY COL, DATA
       union       
       SELECT COL, TO_CHAR(COL*30000,'99G999G999'), DATA, TO_CHAR(SYSDATE, 'DD/MM/YY') FROM INTELIG_CONTABILIZA WHERE COL = (
       SELECT MAX(COL) FROM INTELIG_CONTABILIZA WHERE DATA LIKE ('DENTRO%'))
       GROUP BY COL, DATA
       
       
       (SELECT DATA FROM INTELIG_CONTABILIZA WHERE COL = (
       SELECT MIN(COL) FROM INTELIG_CONTABILIZA WHERE DATA LIKE ('DENTRO%')))

       SELECT COL, TO_CHAR(COL*30000,'99G999G999'), DATA "ATUAL", TO_CHAR(SYSDATE, 'DD/MM/YY'),
       
       (SELECT DATA FROM INTELIG_CONTABILIZA WHERE COL = (
       SELECT MIN(COL) FROM INTELIG_CONTABILIZA WHERE DATA LIKE ('DENTRO%'))) "INICIO"
       
       FROM INTELIG_CONTABILIZA WHERE COL = (
       SELECT MAX(COL) FROM INTELIG_CONTABILIZA WHERE DATA LIKE ('DENTRO%'))
       GROUP BY COL, DATA
       
       fis_monta_livro_saida
       
       SELECT * FROM USER_OBJECTS WHERE STATUS = 'INVALID'
       SELECT DISTINCT OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'INVALID'
       
       
       SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TABLE_NAME = 'COR_IDF'
       
       
       SELECT * FROM USER_OBJECTS WHERE STATUS = 'INVALID' AND OBJECT_NAME IN (       SELECT TRIGGER_NAME FROM USER_TRIGGERS WHERE TABLE_NAME = 'COR_DOF')
       
       SELECT OBJECT_NAME, B.STATUS FROM USER_OBJECTS B
       WHERE OBJECT_NAME 
       IN (SELECT TRIGGER_NAME FROM USER_TRIGGERS A WHERE TABLE_NAME = 'COR_IDF')
       
       
       