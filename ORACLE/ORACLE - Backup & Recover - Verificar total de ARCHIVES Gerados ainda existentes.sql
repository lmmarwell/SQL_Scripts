
SELECT To_char(completion_time , 'DD/MM/YYYY DY') DATA, COUNT(*) "ARCHIVES",
Round(SUM((blocks*block_size)/1024/1024/1024),1) "TAMANHO GB"
FROM V$ARCHIVED_LOG
GROUP BY To_char(completion_time , 'DD/MM/YYYY DY')
ORDER BY 1;

