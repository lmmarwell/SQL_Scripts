create or replace procedure analyze_table is
  vsql     varchar2(32767) default null;
  ocursor  integer;
  olcursor integer;
	iexecute integer;
  vtable   varchar2(30);
  icount   integer default 0;  
begin
  vsql := 'select table_name from user_tables order by table_name';
  ocursor := dbms_sql.open_cursor;    
  dbms_sql.parse(ocursor, vsql, dbms_sql.v7);
  dbms_sql.define_column(ocursor, 1, vtable, 30);
  iexecute := dbms_sql.execute(ocursor);
  if iexecute < 0 then
    return;
  end if;
  loop
    if dbms_sql.fetch_rows(ocursor) > 0 then
      dbms_sql.column_value(ocursor, 1, vtable);
      vsql := 'ANALYZE TABLE ' || vtable || ' ESTIMATE STATISTICS';
      olcursor := dbms_sql.open_cursor;
      dbms_sql.parse(olcursor, vsql, dbms_sql.v7);
      iexecute := dbms_sql.execute(olcursor);
      dbms_sql.close_cursor(olcursor);
      icount := icount + 1;
      dbms_output.put_line(' Processing Table: ' || vtable);
    else
      exit;
    end if;
  end loop;
  dbms_output.put_line('Tables analyzed:' || icount);
  dbms_sql.close_cursor(ocursor);
end;
/
