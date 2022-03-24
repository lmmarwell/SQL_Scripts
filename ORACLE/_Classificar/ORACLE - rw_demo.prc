create or replace procedure rw_demo is
  infile   utl_file.file_type;
  outfile  utl_file.file_type;
  vnewline varchar2(4000);
  i        pls_integer;
  j        pls_integer := 0;
  seekflag boolean := true;
begin
  -- open a file to read
  infile := utl_file.fopen('ORALOAD', 'in.txt', 'r');
  -- open a file to write
  outfile := utl_file.fopen('ORALOAD', 'out.txt', 'w');

  -- if the file to read was successfully opened
  if utl_file.is_open(infile) then
    -- loop through each line in the file
    loop
      begin
        utl_file.get_line(infile, vnewline);
      
        i := utl_file.fgetpos(infile);
        dbms_output.put_line(to_char(i));
      
        utl_file.put_line(outfile, vnewline, false);
        utl_file.fflush(outfile);
      
        if seekflag = true then
          utl_file.fseek(infile, null, -30);
          seekflag := false;
        end if;
      exception
        when no_data_found then
          exit;
      end;
    end loop;
    commit;
  end if;
  utl_file.fclose(infile);
  utl_file.fclose(outfile);
exception
  when others then
    raise_application_error(-20099, 'Unknown UTL_FILE Error');
end rw_demo;
/
