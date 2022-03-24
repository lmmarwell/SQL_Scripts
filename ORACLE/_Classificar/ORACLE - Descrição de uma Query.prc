create or replace procedure desc_query(p_query in varchar2) is
  l_columnvalue varchar2(4000);
  l_status      integer;
  l_colcnt      number default 0;
  l_cnt         number default 0;
  l_line        long;
  l_desctbl     dbms_sql.desc_tab;
  l_thecursor   integer default dbms_sql.open_cursor;
begin
  dbms_sql.parse(l_thecursor, p_query, dbms_sql.native);
  dbms_sql.describe_columns(c       => l_thecursor,
                            col_cnt => l_colcnt,
                            desc_t  => l_desctbl);

  for i in 1 .. l_colcnt loop
    dbms_output.put_line('------------------------------------------------------'); 
    dbms_output.put_line('Column Type..:' || l_desctbl(i).col_type);
    dbms_output.put_line('Max Length...:' || l_desctbl(i).col_max_len);
    dbms_output.put_line('Name.........:' || l_desctbl(i).col_name);
    dbms_output.put_line('Name Length..:' || l_desctbl(i).col_name_len);
    dbms_output.put_line('');
    dbms_output.put_line('Object Column Schema Name.' || l_desctbl(i).col_schema_name);
    dbms_output.put_line('Schema Name Length..:' || l_desctbl(i).col_schema_name_len);
    dbms_output.put_line('Precision...........:' || l_desctbl(i).col_precision);
    dbms_output.put_line('Scale...............:' || l_desctbl(i).col_scale);
    dbms_output.put_line('Charsetid...........:' || l_desctbl(i).col_charsetid);
    dbms_output.put_line('Charset Form........:' || l_desctbl(i).col_charsetform);
    if (l_desctbl(i).col_null_ok) then
      dbms_output.put_line('Nullable............:Y');
    else
      dbms_output.put_line('Nullable............:N');
    end if;
  end loop;
  dbms_sql.close_cursor(l_thecursor);
exception
  when others then
    dbms_sql.close_cursor(l_thecursor);
    raise;
end desc_query;
/
