
col filesystem form a22
col phyrds form 999,999,999,999
col phyblkrd form 999,999,999,999
col phywrts form 999,999,999,999
col phyblkwrt form 999,999,999,999
col AvgRD form 999.99
col AvgWT form 999.99
col AvgBLKWT form 999.99
col AvgBLKRD form 999.99

break on report

comp avg of avgrd on report
comp avg of avgwt on report
comp avg of avgblkwt on report
comp avg of avgblkrd on report

comp sum of phyrds on report
comp sum of phyblkrd on report
comp sum of phyblkwrt on report
comp sum of phywrts on report

select 
substr(df.file_name,1,22) filesystem, 
sum(f.phyrds) phyrds, 
sum(f.phyblkrd) phyblkrd , 
sum(f.phyrds) / sum(phyrds+phywrts) AvgRD,
sum(f.phywrts) / sum(phyrds+phywrts) AvgWT,
sum(f.phywrts) phywrts, 
sum(f.phyblkwrt) phyblkwrt,
sum(f.phyblkwrt) / sum(f.phyblkrd + f.phyblkwrt) AvgBLKWT,
sum(f.phyblkrd) / sum(f.phyblkrd + f.phyblkwrt) AvgBLKRD
from v$filestat f , dba_data_files df
where f.file#=df.file_id
group by substr(df.file_name,1,22);
