declare
  dt_ant    varchar2(8);
  dt_atual  varchar2(8);
  v_sql     varchar2(1000);
begin
  select to_char(sysdate - 8, 'ddmmyyyy')
    into dt_ant
    from dual;
  select to_char(sysdate, 'ddmmyyyy')
    into dt_atual
    from dual;
  v_sql := 'select to_char(sysdate - 8, ''ddmmyyyy'') "' || dt_ant   || '",' || chr(10) ||
           '       to_char(sysdate, ''ddmmyyyy'') "'     || dt_atual || '"'  || chr(10) ||
           '    from dual';
  dbms_output.put_line(v_sql);
  execute immediate v_sql;
end;
