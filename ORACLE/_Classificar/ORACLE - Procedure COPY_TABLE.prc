create or replace procedure copy(source in varchar2, destination in varchar2) is
  id_var             number;
  name_var           varchar2(30);
  birthdate_var      date;
  source_cursor      integer;
  destination_cursor integer;
  ignore             integer;
begin

  -- Prepare a cursor to select from the source table: 
  source_cursor := dbms_sql.open_cursor;
  dbms_sql.parse(source_cursor,
                 'SELECT id, name, birthdate FROM ' || source,
                 dbms_sql.native);
  dbms_sql.define_column(source_cursor, 1, id_var);
  dbms_sql.define_column(source_cursor, 2, name_var, 30);
  dbms_sql.define_column(source_cursor, 3, birthdate_var);
  ignore := dbms_sql.execute(source_cursor);

  -- Prepare a cursor to insert into the destination table: 
  destination_cursor := dbms_sql.open_cursor;
  dbms_sql.parse(destination_cursor,
                 'INSERT INTO ' || destination ||
                 ' VALUES (:id_bind, :name_bind, :birthdate_bind)',
                 dbms_sql.native);

  -- Fetch a row from the source table and insert it into the destination table: 
  loop
    if dbms_sql.fetch_rows(source_cursor) > 0 then
      -- get column values of the row 
      dbms_sql.column_value(source_cursor, 1, id_var);
      dbms_sql.column_value(source_cursor, 2, name_var);
      dbms_sql.column_value(source_cursor, 3, birthdate_var);
    
      -- Bind the row into the cursor that inserts into the destination table. You 
      -- could alter this example to require the use of dynamic SQL by inserting an 
      -- if condition before the bind. 
      dbms_sql.bind_variable(destination_cursor, ':id_bind', id_var);
      dbms_sql.bind_variable(destination_cursor, ':name_bind', name_var);
      dbms_sql.bind_variable(destination_cursor, ':birthdate_bind', birthdate_var);
      ignore := dbms_sql.execute(destination_cursor);
    else
    
      -- No more rows to copy: 
      exit;
    end if;
  end loop;

  -- Commit and close all cursors: 
  commit;
  dbms_sql.close_cursor(source_cursor);
  dbms_sql.close_cursor(destination_cursor);
exception
  when others then
    if dbms_sql.is_open(source_cursor) then
      dbms_sql.close_cursor(source_cursor);
    end if;
    if dbms_sql.is_open(destination_cursor) then
      dbms_sql.close_cursor(destination_cursor);
    end if;
    raise;
end;
/
