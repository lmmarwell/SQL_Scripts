--set serveroutput on size 1000000;
declare
  cursor_id    integer;
  v_tablenames varchar2(30);
  v_counter    number(10) default 0;
  cursor rec_finder is select table_name from user_tables;
begin
  open rec_finder;
  loop
    fetch rec_finder into v_tablenames;
    exit when rec_finder%notfound;
    cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(cursor_id, 'analyze table ' || v_tablenames || ' estimate stats', dbms_sql.native);
    dbms_sql.close_cursor(cursor_id);
    v_counter := v_counter + 1;
    dbms_output.put_line(' Processing Table: ' || v_tablenames);
  end loop;
  dbms_output.put_line('Tables analyzed:' || v_counter);
  close rec_finder;
end;
