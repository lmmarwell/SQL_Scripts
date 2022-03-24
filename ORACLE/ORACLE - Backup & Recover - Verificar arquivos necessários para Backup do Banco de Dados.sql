col filesystem for a25
col file_name for a53

select substr(file_name,1,22) filesystem, file_name from dba_data_files
union
select substr(member,1,22) filesystem, member from v$logfile
union
select substr(name,1,22) filesystem, name from v$controlfile
order by 1,2
/

