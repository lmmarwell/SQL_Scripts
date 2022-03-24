declare 
  p_tabname varchar2(32767);
begin 
  p_tabname := 'SYN_PRCGER_IMPRESSAO';
  fisc33.bon_analisa_tabela.informacoes (p_tabname);
	dbms_output.put_line('');
	commit; 
end;