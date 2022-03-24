declare
  cursor crAtualiza is
    select cpk.owner,
           cpk.table_name,
           ccp.column_name,
           seq.sequence_name,
           lower('select max(' || ccp.column_name || ') from ' || cpk.owner || '.' || cpk.table_name) cmd_table,
           seq.cmd_sequence_curr,
           seq.cmd_sequence_next
      from sys.all_constraints cpk,
           sys.all_cons_columns ccp,
           (select o.owner,
                   o.object_name  sequence_name,
                   substr(o.object_name, 4, length(o.object_name)) table_name,
                   lower('select ' || o.owner || '.' || o.object_name || '.currval from dual') cmd_sequence_curr,
                   lower('select ' || o.owner || '.' || o.object_name || '.nextval from dual') cmd_sequence_next
              from sys.all_objects o
             where o.owner       = 'SANFOM'
               and o.object_type = 'SEQUENCE'
               and o.object_name like 'SQ_TB%') seq
     where seq.table_name        = cpk.table_name
       and ccp.owner             = cpk.owner
       and ccp.constraint_name   = cpk.constraint_name
       and ccp.table_name        = cpk.table_name
       and cpk.constraint_type = 'P'
       and cpk.table_name  in (select substr(o.object_name, 4, length(o.object_name))
                                 from sys.all_objects o
                                where o.owner       = 'SANFOM'
                                  and o.object_type = 'SEQUENCE'
                                  and o.object_name like 'SQ_TB%');
  rcAtualiza crAtualiza%rowtype;
  iCount   number(10)     default 0;
  iAtual   number(10)     default 0;
  iProximo number(10)     default 0;
  iUltimo  number(10)     default 0;
  iSeq     number(10)     default 0;
  sSql     varchar2(1000) default null;
begin
  open crAtualiza;
  loop
    fetch crAtualiza into rcAtualiza;
    exit when crAtualiza%notfound;
    dbms_output.put_line('Atualizando a tabela: ' || rcAtualiza.table_name || ' - ' || 'Sequence: ' || rcAtualiza.sequence_name);
    execute immediate rcAtualiza.cmd_sequence_next into iProximo;
    execute immediate rcAtualiza.cmd_table         into iUltimo;
    
    if iProximo < iUltimo then
      for iCount in iProximo .. iUltimo loop
        execute immediate rcAtualiza.cmd_sequence_next into iAtual;
      end loop;
    end if;
    
  end loop;  
  close crAtualiza;
end;

/*
declare
  dt_ant    varchar2(8);
  dt_atual  varchar2(8);
  v_sql     varchar2(1000);
begin
  select to_char(sysdate - 8, 'ddmmyyyy')
    into dt_ant
    from dual;
  select to_char(sysdate, 'ddmmyyyy')
    into dt_atual
    from dual;
  v_sql := 'select to_char(sysdate - 8, ''ddmmyyyy'') "' || dt_ant   || '",' || chr(10) ||
           '       to_char(sysdate, ''ddmmyyyy'') "'     || dt_atual || '"'  || chr(10) ||
           '    from dual';
  dbms_output.put_line(v_sql);
  execute immediate v_sql;
end;
*/

--------------------------------------------------------------------------------
select lower('select ' || o.owner || '.' || o.object_name || '.nextval from dual;') comando
  from sys.all_objects o
 where o.owner       = 'SANFOM'
   and o.object_type = 'SEQUENCE'
   and o.object_name like 'SQ_TB%';

select lower('select * from ' || o.owner || '.' || substr(o.object_name, 4, length(o.object_name)) || ';') comando
  from sys.all_objects o
 where o.owner       = 'SANFOM'
   and o.object_type = 'SEQUENCE'
   and o.object_name like 'SQ_TB%';

select cpk.owner,
       cpk.table_name,
       ccp.column_name,
       seq.sequence_name,
       lower('select max(' || ccp.column_name || ') into saida from ' || cpk.owner || '.' || cpk.table_name) cmd_table,
       seq.cmd_sequence_curr,
       seq.cmd_sequence_next
  from sys.all_constraints cpk,
       sys.all_cons_columns ccp,
       (select o.owner,
               o.object_name  sequence_name,
               substr(o.object_name, 4, length(o.object_name)) table_name,
               lower('select ' || o.owner || '.' || o.object_name || '.currval into saida from dual') cmd_sequence_curr,
               lower('select ' || o.owner || '.' || o.object_name || '.nextval into saida from dual') cmd_sequence_next
          from sys.all_objects o
         where o.owner       = 'SANFOM'
           and o.object_type = 'SEQUENCE'
           and o.object_name like 'SQ_TB%') seq
 where seq.table_name        = cpk.table_name
   and ccp.owner             = cpk.owner
   and ccp.constraint_name   = cpk.constraint_name
   and ccp.table_name        = cpk.table_name
   and cpk.constraint_type = 'P'
   and cpk.table_name  in (select substr(o.object_name, 4, length(o.object_name))
                             from sys.all_objects o
                            where o.owner       = 'SANFOM'
                              and o.object_type = 'SEQUENCE'
                              and o.object_name like 'SQ_TB%');