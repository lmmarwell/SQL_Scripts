create or replace procedure sp_oracle_excel(i_file_name in varchar2) as
  filename  utl_file.file_type;
  filename1 varchar2(1000);
  cursor c1 is
    select *
      from s5b.it_message;
  varc1 c1%rowtype;
begin
  filename1 := i_file_name || '_' || to_char(sysdate, 'yyyymmdd') || '.txt';
  filename  := utl_file.fopen('\', filename1, 'W');
  utl_file.put_line(filename,
                    'cd_mensagem' || ',' ||
                    'ds_mensagem' || ',' ||
                    'ds_mensagem_detalhada' || ',' ||
                    'fl_grava_contrato');
  open c1;
  loop
    fetch c1
      into varc1;
    exit when c1%notfound;
    utl_file.put_line(filename,
                      '"' || varc1.cd_mensagem           || '"' || ' ,' ||
                      '"' || varc1.ds_mensagem           || '"' || ' ,' ||
                      '"' || varc1.ds_mensagem_detalhada || '"' || ' ,' ||
                      '"' || varc1.fl_grava_contrato     || '"');
  end loop;
  utl_file.fclose(filename);
exception
  when utl_file.invalid_operation then
    dbms_output.put_line('Operação inválida no arquivo - ' || sqlerrm);
    utl_file.fclose(filename);
  when utl_file.write_error then
    dbms_output.put_line('Erro de gravação no arquivo - ' || sqlerrm);
    utl_file.fclose(filename);
  when utl_file.invalid_path then
    dbms_output.put_line('Diretório inválido - ' || sqlerrm);
    utl_file.fclose(filename);
  when utl_file.invalid_mode then
    dbms_output.put_line('Modo de acesso inválido - ' || sqlerrm);
    utl_file.fclose(filename);
  when others then
    dbms_output.put_line('Problemas na geração do arquivo - ' || sqlerrm);
    utl_file.fclose(filename);
end sp_oracle_excel;
/
