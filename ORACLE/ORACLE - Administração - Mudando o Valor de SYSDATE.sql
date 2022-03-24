-- Compara os valores de SYSDATE com o valor de SYSTIMESTAMP
select to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss') as "Sysdate",
       to_char(systimestamp, 'dd/mm/rrrr hh24:mi:ss') as "Systimestamp"
  from dual;

-- Alteramos o valor da varival FIXED_DATE de ambiente do Oracle para uma data qualquer
alter system set fixed_date = '2013-08-21 01:00:00';


-- Compara, novamente, os valores de SYSDATE com o valor de SYSTIMESTAMP
select to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss') as "Data Sysdate",
       to_char(systimestamp, 'dd/mm/rrrr hh24:mi:ss') as "Data Systimestamp"
  from dual;
  
-- Alteramos o valor da varival FIXED_DATE de ambiente do Oracle para NONE
alter system set fixed_date = none;

-- Compara os valores de SYSDATE com o valor de SYSTIMESTAMP
select to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss') as "Data Sysdate",
       to_char(systimestamp, 'dd/mm/rrrr hh24:mi:ss') as "Data Systimestamp"
  from dual;
