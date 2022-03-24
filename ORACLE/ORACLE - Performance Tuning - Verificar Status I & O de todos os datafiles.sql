

set pagesize 200; 
set space 1 

column pbr format 99999999 heading 'Physical|Blk Read' 
column pbw format 999999 heading 'Physical|Blks Wrtn' 
column pyr format 999999 heading 'Physical|Reads' 
column readtim format 99999999 heading 'Read|Time' 
column name format a70 heading 'DataFile Name' 
column writetim format 99999999 heading 'Write|Time' 


compute sum of f.phyblkrd, f.phyblkwrt on report 

select fs.name name, f.phyblkrd pbr, f.phyblkwrt pbw, 
f.readtim, f.writetim 
from v$filestat f, v$datafile fs 
where f.file# = fs.file# 
order by fs.name ;