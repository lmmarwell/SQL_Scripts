col component for a25
col final_size for 999,999,999,999 head "Final"
col started for a20

SELECT component, oper_type, final_size, to_char(start_time ,'mm/dd/yyyy hh24:mi:ss') started
FROM v$sga_resize_ops
WHERE status ='COMPLETE'
ORDER BY started desc, component;

