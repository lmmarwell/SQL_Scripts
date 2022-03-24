declare
  lffilelog utl_file.file_type;
  lspath varchar2(50) := 'c:\';
  lsfile varchar2(50) := 'file';
begin
  lffilelog := utl_file.fopen(lspath, lsfile || '.txt', 'w');
  for r in (select from table) loop
    utl_file.put_line(lffilelog, r.row);
  end loop;
  utl_file.fclose_all;
exception
  when utl_file.invalid_operation then
    utl_file.put_line(lffilelog, sqlerrm);
    utl_file.put_line(lffilelog, ' Invalid File open Operation');
    utl_file.fclose_all;
    raise_application_error(-20051, 'Invalid File open Operation');
  when utl_file.invalid_filehandle then
    utl_file.put_line(lffilelog, sqlerrm);
    utl_file.put_line(lffilelog, ' Invalid File Name');
    utl_file.fclose_all;
    raise_application_error(-20052, 'Invalid File Name');
  when utl_file.read_error then
    utl_file.put_line(lffilelog, sqlerrm);
    utl_file.put_line(lffilelog, ' Read Error');
    utl_file.fclose_all;
    raise_application_error(-20053, 'Read Error');
  when others then
    utl_file.put_line(lffilelog, sqlerrm);
    utl_file.fclose_all;
    dbms_output.put_line(sqlerrm);
    rollback;
end;
reply
with quote
