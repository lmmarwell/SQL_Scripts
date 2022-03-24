declare 
	crlf constant varchar2(2) default chr(13) || chr(10);
	arquivo_saida utl_file.file_type;
	vsqlerrm      varchar2(1024) := null ;
	diretorio     varchar2(1024) := '/interfaces/relatorios/convenio11503/input';
	arquivo       varchar2(1024) := 'arquivo.txt';
begin
	-- abre arquivo  
	arquivo_saida := utl_file.fopen(diretorio, arquivo,'W',9192); -- 'w'); --   
	-- abre um cursor com os dados a serem gravados
	for c in (select pfj_codigo || ' ' || mnemonico || crlf coluna from fisc33.bon_pessoa_homolog_in86) loop
		-- escreve no arquivo                       
		utl_file.put_line(arquivo_saida, c.coluna);                       
	end loop;
	-- fecha arquivo  
	utl_file.fclose(arquivo_saida);
exception
	when utl_file.invalid_operation then
		dbms_output.put_line('Operação inválida no arquivo.'||sqlerrm);
		utl_file.fclose(arquivo_saida);
	when utl_file.write_error then
		dbms_output.put_line('Erro de gravação no arquivo.'||sqlerrm);
		utl_file.fclose(arquivo_saida);
	when utl_file.invalid_path then
		dbms_output.put_line('Diretório inválido.'||sqlerrm);
		utl_file.fclose(arquivo_saida);
	when utl_file.invalid_mode then
		dbms_output.put_line('Modo de acesso inválido.'||sqlerrm);
		utl_file.fclose(arquivo_saida);
	when others then
		dbms_output.put_line('Problemas na geração do arquivo.'||sqlerrm);
	utl_file.fclose(arquivo_saida);
end;
