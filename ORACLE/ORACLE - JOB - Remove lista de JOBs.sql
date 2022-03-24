begin
  -- Declara a variável que receberá o resultado do select.  
  declare
    vsql     varchar2(32767) default null;
    ocursor  integer;
    iexecute integer;
    job_id   number;
  begin  
    -- Captura a identificação da Job.  
    vsql := 'select job from user_jobs where schema_user = ''FISC33''';
    ocursor := dbms_sql.open_cursor;
    dbms_sql.parse(ocursor, vsql, dbms_sql.v7);
    dbms_sql.define_column(ocursor, 1, job_id);
    iexecute := dbms_sql.execute(ocursor);
    if iexecute < 0 then
      return;
    end if;
    -- Remove a lista de job's recuperado.
    loop
      if dbms_sql.fetch_rows(ocursor) > 0 then
        dbms_sql.column_value(ocursor, 1, job_id);
        dbms_job.remove(job_id);
      else
        exit;
      end if;
    end loop;
    dbms_sql.close_cursor(ocursor);
    commit;
  end;
end;
