create or replace procedure debug_proc.varre_clob is 
   Campo    clob;
   Texto    clob;
   iPosicao number(32) default 0;
   iTamanho number(32) default 0;
   sLinha   varchar2(32765);
begin 
  select tet.tx_trace
    into Campo
    from tbex.tst_execucao_trace  tet
   where tet.cd_resultado = 16239;

  Texto    := Campo;
  iTamanho := dbms_lob.getlength(Texto);
  iPosicao := dbms_lob.instr(Texto, chr(10));

  loop
    sLinha   := trim(replace(replace(replace(dbms_lob.substr(Texto, iPosicao, 1), chr(13), null), chr(10), null), chr(13) || chr(10), null));
    dbms_output.put_line(sLinha);
    Texto    := substr(Texto, iPosicao + 1, iTamanho);
    iTamanho := dbms_lob.getlength(Texto);
    if iTamanho = 0 then
      exit;
    end if;
    iPosicao := dbms_lob.instr(Texto, chr(10));
    if iPosicao = 0 then
      iPosicao := dbms_lob.instr(Texto, '!');
    end if;
  end loop;
end;
/
