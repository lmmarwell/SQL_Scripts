

set feedback off

set lines 155
break on report
compute sum of WRITEPCT on report
compute sum of READPCT on report
compute sum of IOPCT on report

select * from
( SELECT TABLESPACE_NAME
, sum(PHYRDS) as PHYRDS
, sum(PHYWRTS) as PHYWRTS
, sum(PHYBLKRD) as PHYBLKRD
, sum(PHYBLKWRT) as PHYBLKWRT
, sum(READPCT) as READPCT
, sum(WRITEPCT) as WRITEPCT
, sum(IOPCT) as IOPCT
FROM
( SELECT
ts.name
as tablespace_name
, fs.PHYRDS
, fs.PHYWRTS
, fs.PHYBLKRD
, fs.PHYBLKWRT
, 100 * ratio_to_report(fs.PHYBLKRD) over () as readpct
, 100 * ratio_to_report(fs.PHYBLKWRT) over () as writepct
, 100 * ratio_to_report(fs.PHYBLKRD+fs.PHYBLKWRT) over () as iopct
FROM V$FILESTAT fs, V$DATAFILE df, v$tablespace ts, dba_tablespaces dt
WHERE fs.file# = df.file#
AND df.ts# = ts.ts#
AND dt.tablespace_name = ts.name )
GROUP BY tablespace_name
ORDER BY iopct desc )
where rownum < 11 ; 