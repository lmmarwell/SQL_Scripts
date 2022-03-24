select * from dict
where table_name like '%JOB%'

select *
  from sys.dba_jobs
 where log_user = 'DEBUG_PROC'
  
declare
  id_job number;
begin
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 368, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 370, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 391, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 411, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 412, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 413, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 414, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 415, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 416, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 417, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 418, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 419, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 420, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 421, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 422, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 423, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 424, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 425, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
  dbms_job.submit(id_job, 's5b.xr_executa_teste.executaperguntaproducao(''XR'', 426, null);', (sysdate + 1.4));
  dbms_output.put_line(id_job);
end;
