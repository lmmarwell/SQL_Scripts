create or replace procedure envia_xml is
  v_dir varchar2(7) := 'http://aplfms:7777/dload';
  v_nome varchar2(15) := 'vd_pecas_pq.xml';
  v_file utl_file.file_type ;
  v_clob clob ;
  v_buffer_size varchar2(32767) ;
  v_buffer varchar2(32767) ;
  v_amount binary_integer := 32767;
  v_pos integer := 1 ;
begin
  select p.lin.getclobval()
    into v_clob
    from pc_pq_lin_xml1 p
   where p.sqfile = 1 ;
  v_file := utl_file.fopen(v_dir, v_nome , 'w', v_buffer_size);
  loop
    dbms_lob.read(v_clob, v_amount, v_pos, v_buffer);
    utl_file.put(v_file, v_buffer);
    v_pos := v_pos + v_amount;
  end loop;
exception when others then
  dbms_output.put_line(sqlerrm);
  utl_file.fclose(v_file);
end envia_xml;
/
