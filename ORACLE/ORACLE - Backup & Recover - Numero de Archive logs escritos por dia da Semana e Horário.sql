
col total forma 999,999
col np noprint
col "00"  form 099
col "01"  form 099
col "02"  form 099
col "03"  form 099
col "04"  form 099
col "05"  form 099
col "06"  form 099
col "07"  form 099
col "08"  form 099
col "09"  form 099
col "10"  form 099
col "11"  form 099
col "12"  form 099
col "13"  form 099
col "14"  form 099
col "15"  form 099
col "16"  form 099
col "17"  form 099
col "18"  form 099
col "19"  form 099
col "20"  form 099
col "21"  form 099
col "22"  form 099
col "23"  form 099
col "DIA SEMANA" form a4

alter session set NLS_DATE_FORMAT='DD/MM/YYYY';

select trunc(min(first_time)) DATA_INICIAL , trunc(max(first_time)) DATA_FINAL
from v$loghist
/
alter session set NLS_DATE_FORMAT='DD-MON-RR';

select
to_char(first_time,'D') np ,
to_char(first_time,'DY') "DIA SEMANA",
sum(decode(to_char(first_time,'HH24'),'00',1,0)) "00" ,
sum(decode(to_char(first_time,'HH24'),'01',1,0)) "01" ,
sum(decode(to_char(first_time,'HH24'),'02',1,0)) "02" ,
sum(decode(to_char(first_time,'HH24'),'03',1,0)) "03" ,
sum(decode(to_char(first_time,'HH24'),'04',1,0)) "04" ,
sum(decode(to_char(first_time,'HH24'),'05',1,0)) "05" ,
sum(decode(to_char(first_time,'HH24'),'06',1,0)) "06" ,
sum(decode(to_char(first_time,'HH24'),'07',1,0)) "07" ,
sum(decode(to_char(first_time,'HH24'),'08',1,0)) "08" ,
sum(decode(to_char(first_time,'HH24'),'09',1,0)) "09" ,
sum(decode(to_char(first_time,'HH24'),'10',1,0)) "10" ,
sum(decode(to_char(first_time,'HH24'),'11',1,0)) "11" ,
sum(decode(to_char(first_time,'HH24'),'12',1,0)) "12" ,
sum(decode(to_char(first_time,'HH24'),'13',1,0)) "13" ,
sum(decode(to_char(first_time,'HH24'),'14',1,0)) "14" ,
sum(decode(to_char(first_time,'HH24'),'15',1,0)) "15" ,
sum(decode(to_char(first_time,'HH24'),'16',1,0)) "16" ,
sum(decode(to_char(first_time,'HH24'),'17',1,0)) "17" ,
sum(decode(to_char(first_time,'HH24'),'18',1,0)) "18" ,
sum(decode(to_char(first_time,'HH24'),'19',1,0)) "19" ,
sum(decode(to_char(first_time,'HH24'),'20',1,0)) "20" ,
sum(decode(to_char(first_time,'HH24'),'21',1,0)) "21" ,
sum(decode(to_char(first_time,'HH24'),'22',1,0)) "22" ,
sum(decode(to_char(first_time,'HH24'),'23',1,0)) "23"
from v$loghist
group by to_char(first_time,'D'), to_char(first_time,'DY')
/