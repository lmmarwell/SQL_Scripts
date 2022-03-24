
col total forma 999,999
col np noprint
col data_inicial form a22
col data_final   form a22
col "DIA" form a4
col total form 9999

alter session set NLS_DATE_FORMAT='DD/MM/YYYY';

select trunc(min(first_time)) DATA_INICIAL,
trunc(max(first_time)) DATA_FINAL
from v$loghist
/

SELECT to_char(first_time,'D') np , to_char(first_time,'DY') "DIA", COUNT(*) TOTAL
FROM V$LOGHIST
GROUP BY to_char(first_time,'D'), to_char(first_time,'DY')
order by 1
/

alter session set NLS_DATE_FORMAT='DD-MON-RR';