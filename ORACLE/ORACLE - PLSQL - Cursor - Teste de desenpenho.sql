--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 12:00:34.707000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 12:00:34.832000000
-- Tempo processamento..........: +000000 00:00:00.125000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_count   number default 1;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  for cr_emitente in (select coe.cd_grupo_fat,
                             coe.tp_documento,
                             coe.nu_documento,
                             coe.nu_ddd_cel,
                             coe.nu_tel_cel
                        from oln.cd_online_emitente coe
                       where length(coe.nu_tel_cel) = 8
                         and coe.nu_ddd_cel = 11) loop
    dbms_output.put_line(cr_emitente.cd_grupo_fat || cr_emitente.tp_documento || cr_emitente.nu_documento || cr_emitente.nu_ddd_cel || cr_emitente.nu_tel_cel);  
    i_count := i_count + 1;
  end loop;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 13:50:28.136000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 13:50:28.292000000
-- Tempo processamento..........: +000000 00:00:00.156000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_count   number default 1;
  cursor cr_emitente is
    select coe.cd_grupo_fat,
           coe.tp_documento,
           coe.nu_documento,
           coe.nu_ddd_cel,
           coe.nu_tel_cel
      from oln.cd_online_emitente coe
     where length(coe.nu_tel_cel) = 8
       and coe.nu_ddd_cel = 11;
  rc_emitente cr_emitente%rowtype;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  for rc_emitente in cr_emitente loop
    dbms_output.put_line(rc_emitente.cd_grupo_fat || rc_emitente.tp_documento || rc_emitente.nu_documento || rc_emitente.nu_ddd_cel || rc_emitente.nu_tel_cel);  
    i_count := i_count + 1;
  end loop;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 12:00:11.338000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 12:00:11.478000000
-- Tempo processamento..........: +000000 00:00:00.140000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_count   number default 1;
  cursor cr_emitente is
    select coe.cd_grupo_fat,
           coe.tp_documento,
           coe.nu_documento,
           coe.nu_ddd_cel,
           coe.nu_tel_cel
      from oln.cd_online_emitente coe
     where length(coe.nu_tel_cel) = 8
       and coe.nu_ddd_cel = 11;
  rc_emitente cr_emitente%rowtype;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  open cr_emitente;
  loop
    fetch cr_emitente into rc_emitente;
    exit when cr_emitente%notfound;
    dbms_output.put_line(rc_emitente.cd_grupo_fat || rc_emitente.tp_documento || rc_emitente.nu_documento || rc_emitente.nu_ddd_cel || rc_emitente.nu_tel_cel);  
    i_count := i_count + 1;
  end loop;
  close cr_emitente;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 13:35:43.002000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 13:35:43.111000000
-- Tempo processamento..........: +000000 00:00:00.109000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_index   number default 1;
  i_count   number default 1;
  cursor cr_emitente is
    select coe.cd_grupo_fat,
           coe.tp_documento,
           coe.nu_documento,
           coe.nu_ddd_cel,
           coe.nu_tel_cel
      from oln.cd_online_emitente coe
     where length(coe.nu_tel_cel) = 8
       and coe.nu_ddd_cel = 11;
  type t_emitente is table of cr_emitente%rowtype index by pls_integer;
  rc_emitente t_emitente;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  open cr_emitente;
  loop
    fetch cr_emitente bulk collect into rc_emitente limit 100;
    for i_index in 1 .. rc_emitente.count loop
      dbms_output.put_line(rc_emitente(i_index).cd_grupo_fat || rc_emitente(i_index).tp_documento || rc_emitente(i_index).nu_documento || rc_emitente(i_index).nu_ddd_cel || rc_emitente(i_index).nu_tel_cel);
      i_count := i_count + 1;
    end loop;     
    exit when cr_emitente%notfound;
  end loop;
  close cr_emitente;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 13:38:16.585000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 13:38:16.725000000
-- Tempo processamento..........: +000000 00:00:00.140000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_index   number default 1;
  i_count   number default 1;
  cursor cr_emitente is
    select coe.cd_grupo_fat,
           coe.tp_documento,
           coe.nu_documento,
           coe.nu_ddd_cel,
           coe.nu_tel_cel
      from oln.cd_online_emitente coe
     where length(coe.nu_tel_cel) = 8
       and coe.nu_ddd_cel = 11;
  type t_emitente is table of cr_emitente%rowtype index by pls_integer;
  rc_emitente t_emitente;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  open cr_emitente;
  loop
    fetch cr_emitente bulk collect into rc_emitente limit 100;
    for i_index in rc_emitente.first .. rc_emitente.last loop
      dbms_output.put_line(rc_emitente(i_index).cd_grupo_fat || rc_emitente(i_index).tp_documento || rc_emitente(i_index).nu_documento || rc_emitente(i_index).nu_ddd_cel || rc_emitente(i_index).nu_tel_cel);
      i_count := i_count + 1;
    end loop;     
    exit when cr_emitente%notfound;
  end loop;
  close cr_emitente;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 12:08:16.064000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 12:08:16.267000000
-- Tempo processamento..........: +000000 00:00:00.203000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_index   number default 1;
  i_count   number default 1;
  type t_emitente is table of oln.cd_online_emitente%rowtype;
  tb_emitente t_emitente;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  select coe.*
    bulk collect into tb_emitente
    from oln.cd_online_emitente coe
   where length(coe.nu_tel_cel) = 8
     and coe.nu_ddd_cel = 11;
  for i_index in 1 .. tb_emitente.count loop
    dbms_output.put_line(tb_emitente(i_index).cd_grupo_fat || tb_emitente(i_index).tp_documento || tb_emitente(i_index).nu_documento || tb_emitente(i_index).nu_ddd_cel || tb_emitente(i_index).nu_tel_cel);
    i_count := i_count + 1;
  end loop;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/
--------------------------------------------------------------------------------
-- Inicio do processamento......: 02/08/2012 12:09:28.277000000
-- Total de registros afetados..: 351
-- Fim do processamento.........: 02/08/2012 12:09:28.464000000
-- Tempo processamento..........: +000000 00:00:00.187000000
--------------------------------------------------------------------------------
declare
  dt_inicio timestamp;
  dt_fim    timestamp;
  i_index   number default 1;
  i_count   number default 1;
  type t_emitente is table of oln.cd_online_emitente%rowtype;
  tb_emitente t_emitente;
begin
  dbms_output.disable;
  dbms_output.enable(1000000000000);    
  dbms_output.enable;
  dt_inicio := systimestamp;
  dbms_output.put_line('Inicio do processamento......: ' || to_char(dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
  select coe.*
    bulk collect into tb_emitente
    from oln.cd_online_emitente coe
   where length(coe.nu_tel_cel) = 8
     and coe.nu_ddd_cel = 11;
  for i_index in tb_emitente.first .. tb_emitente.last loop
    dbms_output.put_line(tb_emitente(i_index).cd_grupo_fat || tb_emitente(i_index).tp_documento || tb_emitente(i_index).nu_documento || tb_emitente(i_index).nu_ddd_cel || tb_emitente(i_index).nu_tel_cel);
    i_count := i_count + 1;
  end loop;
  dbms_output.put_line('Total de registros afetados..: ' || i_count);
  dt_fim := systimestamp;
  dbms_output.put_line('Fim do processamento.........: ' || to_char(dt_fim,'dd/mm/yyyy hh24:mi:ss.ff'));
  dbms_output.put_line('Tempo processamento..........: ' || to_char(dt_fim - dt_inicio,'dd/mm/yyyy hh24:mi:ss.ff'));
end;
/