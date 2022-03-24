
--INI.ORA
--UTL_FILE_DIR=(c:\temp, c:\temp1)  ou  UTL_FILE_DIR=*
--ou
--UTL_FILE_DIR=c:\temp
--UTL_FILE_DIR=c:\temp1  --um em baixo do outro

--Para mapear um unidade de rede   
--Windows 2000  
-- Control Panel|Administrative Tools|OracleServiceXXXXX|Propertis|log on Tab
-- Escolha o botão This Account e entre com a conta apropriada.

--Escrita

declare
  buffer_size integer := 100000;
  saida       utl_file.file_type; -- declaração do file handle
  linha       varchar2(1022);
begin
  saida := utl_file.fopen('/u01/leo', 'SAIDA.TXT', 'A', 32000); --Abre o arquivo em:  A-Acrescentar, R-Leitura, W-Escrita
  -- 32000  é o tamanho máximo da linha apartir do 8.0.5.
  -- 1 linha
  utl_file.put(saida, 'T'); -- armazena o texto no buffer sem o caracter de final de linha
  utl_file.put(saida, 'E');
  utl_file.put(saida, 'S');
  utl_file.put(saida, 'T');
  utl_file.put(saida, 'E');
  utl_file.new_line(saida); -- inclui o conteudo do buffer com o caracter de final de linha no arquivo.
  -- 2 linha
  utl_file.put_line(saida, 'GRAVAÇÃO EXEMPLO 1'); -- inclui uma linha no arquivo com caracter de final de linha.
  -- 3 linha
  utl_file.putf(saida,
                'Neste exemplo %s serão enviados %s argumentos %s  \n Com uma quebra de linha',
                'A',
                '3',
                ':'); -- realiza formatações na linha a se incluida
  utl_file.fflush(saida); --  grava fisicamente todos os dados pendentes no arquivo
  utl_file.fclose(saida); -- fecha o arquivo
exception
  when utl_file.invalid_path then
    raise_application_error(-20000, 'Localização ou Nome do Caminho inválido');
  when utl_file.invalid_mode then
    raise_application_error(-20001,
                            'O parametro <modo> da rotina Fopen está inválido');
  when utl_file.invalid_operation then
    raise_application_error(-20002,
                            'O arquivo não pode ser aberto ou operado como requisitado');
  when utl_file.write_error then
    raise_application_error(-20003,
                            'Um erro do sistema Operacional ocorreu durante a operação de gravação');
  when utl_file.invalid_filehandle then
    raise_application_error(-20004, 'O Handle do arquivo está inválido');
  when utl_file.internal_error then
    raise_application_error(-20004, 'Erro nao epecificado em PL/SQL');
  
end;

---------------------------------------------------------------------------------------------------

--Leitura     

declare
  saida utl_file.file_type; -- declaração do file handle
  linha varchar2(1022);
  msg   varchar2(4000);
begin
  saida := utl_file.fopen('/u01/leo', 'SAIDA.TXT', 'R'); --Abre o arquivo em:  A-Acrescentar, R-Leitura, W-Escrita
  msg   := '';
  loop
    utl_file.get_line(saida, linha); -- leitura de uma linha do arquivo
    msg := msg || linha || chr(10);
  end loop;
exception
  when utl_file.invalid_operation then
    raise_application_error(-20002,
                            'O arquivo não pode ser aberto ou operado como requisitado');
  when utl_file.invalid_filehandle then
    raise_application_error(-20004, 'O Handle do arquivo está inválido');
  when utl_file.read_error then
    raise_application_error(-20005,
                            'Um erro do sistema operacional ocorreu durante a leitura');
  when no_data_found then
    dbms_output.put_line(msg);
    if utl_file.is_open(saida) then
      -- verifica se o arquivo esta aberto
      utl_file.fclose_all; -- fecha todos os arquivos abertos  
    end if;
  when value_error then
    raise_application_error(-20006, 'Verifique o tamanho da linha');
end;
---------------------------------------------------------------------------------------------------

---------------------------
oracle 9ir2
---------------------------

connect sys / manager@dbolap as sysdba;
create or replace directory user_dir as 'C:\rudi\wokdir';
grant read on directory user_dir to hr;
create or replace directory sys_dir as 'C:\rudi\wokdir';
grant read on directory sys_dir to dba;

connect hr / hr@dbolap;
declare
  v_fh        utl_file.file_type;
  v_buffer    varchar2(4000) := 'Hello Utl_File';
  v_exists    boolean;
  v_length    number;
  v_blocksize number;
begin
  --Define quem vai acessar o diretorio
  v_fh := utl_file.fopen('USER_DIR', 'userdata.txt', 'w'); -- UTL_FILE.FOPEN('SYS_DIR', 'userdata.txt', 'w'); 
  utl_file.put_line(v_fh, v_buffer);
  utl_file.fclose(v_fh);
  --Atributos do arquivo
  utl_file.fgetattr('USER_DIR',
                    'userdata.txt',
                    v_exists,
                    v_length,
                    v_blocksize);
  if v_exists then
    dbms_output.put_line('Length is: ' || v_length);
    dbms_output.put_line('Block size is: ' || v_blocksize);
  else
    dbms_output.put_line('File not found.');
  end if;
  -- Copiar um arquivo
  utl_file.fcopy('USER_DIR', 'userdata.txt', 'USER_DIR', 'copy.txt', 1, 10);
  -- Renomiar um arquivo
  utl_file.frename('USER_DIR', 'copy.txt', 'USER_DIR', 'userdata1.txt', true);
  -- Remover um arquivo
  utl_file.fremove('USER_DIR', 'userdata1.txt');

exception
  when utl_file.access_denied then
    dbms_output.put_line('No Access!!!');
  when others then
    dbms_output.put_line('SQLERRM: ' || sqlerrm);
end;

/
