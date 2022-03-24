declare
  horas_dia          integer := 24;
  minutos_hora       integer := 60;
  segundos_minuto    integer := 60;
  total_horas_dia    integer;
  total_minutos_dia  integer;
  total_segundos_dia integer;
  atual              date;
begin
  total_horas_dia    := horas_dia;
  total_minutos_dia  := minutos_hora * horas_dia;
  total_segundos_dia := segundos_minuto * minutos_hora * horas_dia;
  atual              := sysdate;
  dbms_output.put_line('data atual:' || to_char(atual, 'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' + 15 horas:' || to_char(atual + (15 / total_horas_dia),'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' - 15 horas:' || to_char(atual –(15 / total_horas_dia),'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' + 30 minutos:' || to_char(atual + (15 / total_minutos_dia),'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' - 30 minutos:' || to_char(atual –(15 / total_minutos_dia),'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' + 20 segundos:' || to_char(atual + (20 / total_segundos_dia),'dd / mon / yyyy hh24 :mi :ss'));
  dbms_output.put_line(' - 20 segundos:' || to_char(atual –(20 / total_segundos_dia),'dd / mon / yyyy hh24 :mi :ss'));
end;
