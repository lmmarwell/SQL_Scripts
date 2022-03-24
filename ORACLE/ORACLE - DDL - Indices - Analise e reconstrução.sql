-- set serveroutput on size 100000;
declare
  t_inicial  number default dbms_utility.get_time;
  vowner     sys.all_indexes.owner%type;
  vidxname   sys.all_indexes.index_name%type;
  vanalyze   varchar2(100);
  vrebuild   varchar2(100);
  vcursor    number;
  vnumrows   integer;
  vheight    sys.index_stats.height%type;
  vlfrows    sys.index_stats.lf_rows%type;
  vdlfrows   sys.index_stats.del_lf_rows%type;
  vdlfperc   number;
  vmaxheight number;
  vmaxdel    number;
  cursor cgetidx is
    select owner,
           index_name
      from sys.all_indexes
     where owner = 'EMI';
--       and table_name = 'EMITENTE_COMPLETO'
--       and index_name in ('IN_EMITENTE_COMPLETO_01',
--                          'IN_EMITENTE_COMPLETO_02',
--                          'IN_EMITENTE_COMPLETO_03');
--     where owner not like '%SYS%';
begin
  dbms_output.put_line('Iniciado as..................: ' || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
  vmaxheight := 1;
  vmaxdel    := 10;
  if cgetidx%isopen then
    close cgetidx;
  end if;
  open cgetidx;
  loop
    fetch cgetidx into vowner, vidxname;
    exit when cgetidx%notfound;
    vcursor := dbms_sql.open_cursor;
    vanalyze := 'ANALYZE INDEX ' || vowner || '.' || vidxname || ' VALIDATE STRUCTURE';
    dbms_output.put_line(vanalyze);
    dbms_sql.parse(vcursor, vanalyze, dbms_sql.v7);
    vnumrows := dbms_sql.execute(vcursor);
    dbms_sql.close_cursor(vcursor);
    begin
      select nvl(height, 0),
             nvl(lf_rows, 0),
             nvl(del_lf_rows, 0)
        into vheight,
             vlfrows,
             vdlfrows
        from sys.index_stats;
    exception
      when no_data_found then
        vheight  := 0;
        vlfrows  := 0;
        vdlfrows := 0;
    end;
    if vdlfrows = 0 then
      vdlfperc := 0;
    else
      vdlfperc := (vdlfrows / vlfrows) * 100;
    end if;
    if (vheight > vmaxheight) or (vdlfperc > vmaxdel) then
      vrebuild := 'ALTER INDEX   ' || vowner || '.' || vidxname || ' REBUILD';
      dbms_output.put_line(vrebuild);
--      dbms_sql.parse(vcursor, vrebuild, dbms_sql.v7);
--      vnumrows := dbms_sql.execute(vcursor);
--      dbms_sql.close_cursor(vcursor);
    end if;
  end loop;
  close cgetidx;
  dbms_output.put_line('Terminou as..................: ' || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
  dbms_output.put_line('Tempo (Decimal)..............: ' || trim(to_char(((dbms_utility.get_time - t_inicial) / 100), '999,999.999999') || ' segundos'));
end;
