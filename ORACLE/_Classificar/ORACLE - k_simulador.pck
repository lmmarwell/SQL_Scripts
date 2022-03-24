create or replace package lmm_simulador is
  type split_table is table of varchar2(32767);
  function split(pv_list in varchar2, pv_del in varchar2 default ',') return split_table pipelined;
  function sequencial(pv_limite in int) return split_table pipelined;
end lmm_simulador;
/
create or replace package body lmm_simulador is
  
	function split(pv_list in varchar2, pv_del in varchar2 default ',') return split_table pipelined as
  -- Função que cria uma tabela simulando a função split do VB
    lc_idx  pls_integer;
    lc_list varchar2(32767) := trim(pv_list);
  begin
    loop
      lc_idx := instr(lc_list, pv_del);
      if lc_idx > 0 then
        pipe row(substr(lc_list, 1, lc_idx - 1));
        lc_list := substr(lc_list, lc_idx + length(pv_del));
      else
        pipe row(lc_list);
        exit;
      end if;
    end loop;
    return;
  end;
  
  function sequencial(pv_limite in int) return split_table pipelined as
	-- Função que cria uma tabela temporaria com um determinado número de linhas sequenciais
    lc_idx  pls_integer;
    lc_list varchar2(32767) := null;
    lc_del  char(1)         := ',';
  begin
    for lc_cont in 1..pv_limite loop
        lc_list := lc_list || lc_cont;
      if lc_cont <> pv_limite then
        lc_list := lc_list || lc_del;
      end if;
    end loop;
    loop
      lc_idx := instr(lc_list, lc_del);
      if lc_idx > 0 then
        pipe row(substr(lc_list, 1, lc_idx - 1));
        lc_list := substr(lc_list, lc_idx + length(lc_del));
      else
        pipe row(to_number(lc_list));
        exit;
      end if;
    end loop;
    return;
  end;
begin
  dbms_output.put(sysdate);
end lmm_simulador;
/
