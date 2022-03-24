--------------------------------------------------------------------------------------------------
-- CONSIDERAR 1 Hora = 60 min
--            1 Min  = 60 seg
--            1 Seg  = Base da unidade de medida
-- Exemplo 01:
--    Tempo em Hora: 1.77
--    Inteiro(1.77) = 1 hora
--    Inteiro(((1.77 - Inteiro(1.77)) * 60)) = 46 Minutos
--    ((46.2 - Inteiro(46,2)) * 60) = 12 Segundos
--    Ficando: 01:46:12
select trunc(1.77) hora, 
       trunc(((1.77 - trunc(1.77)) * 60)) minuto,
       ((46.2 - trunc(46,2)) * 60) segundo, 
       lpad(trunc(1.77), 2, '0')  || ':' ||
       lpad(((1.77 - trunc(1.77)) * 60), 2, '0') || ':' ||
       lpad(((46.2 - trunc(46,2)) * 60), 2, '0') tempo
  from dual
-- Exemplo 02:
--    Tempo em Minuto: 1774.45
--    Inteiro(1774.45 / 60) = 6 Horas
--    Inteiro(((1774.45 / 60) - Inteiro(1774.45 / 60)) * 60) = 34 Minutos
--    Inteiro((1774.45 - Inteiro(1774.45)) * 60) = 27 Segundos
--    Ficando: 29:34:27
select trunc(1774.45 / 60)  hora, 
       trunc(((1774.45 / 60) - trunc(1774.45 / 60)) * 60) minuto,
       trunc((1774.45 - trunc(1774.45)) * 60) segundo,
       lpad(trunc(1774.45 / 60), 2, '0')  || ':' ||
       lpad(trunc(((1774.45 / 60) - trunc(1774.45 / 60)) * 60), 2, '0') || ':' ||
       lpad(trunc((1774.45 - trunc(1774.45)) * 60), 2, '0') tempo
  from dual
-- Exemplo 03:
--    Tempo em Segundos: 24008.540000
--    Inteiro((24008.540000 / 60 / 60)) = 6 Horas
--    Inteiro((24008.540000 / 60 / 100))  = 4 Minuitos
--    Inteiro(((24008.540000 / 60) - Inteiro(24008.540000 / 60)) * 60) = 9 Segundos
--    Ficando: 06:04:09
--    Ou
--    Inteiro((24008.540000 / 60 / 60)) = 6 Horas
--    Inteiro((24008.540000 / 60 / 100))  = 4 Minuitos
--    Inteiro(((24008.540000 / 60) - Inteiro(24008.540000 / 60)) * 60) = 8 Segundos
--    Ficando: 06:04:08
--    Ou
--    Inteiro((24008.540000 / 60 / 60)) = 6 Horas
--    Inteiro((24008.540000 / 60 / 100))  = 4 Minuitos
--    (((24008.540000 / 60) - Inteiro(24008.540000 / 60)) * 60) = 8,54 Segundos
--    Ficando: 06:04:08,54
select trunc((24008.540000 / 60 / 60))  hora, 
       trunc((24008.540000 / 60 / 100)) minuto, 
       round(((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60) segundo,
       lpad(trunc(24008.540000 / 60 / 60), 2, '0')  || ':' ||
       lpad(trunc(24008.540000 / 60 / 100), 2, '0') || ':' ||
       lpad(round((((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60)), 2, '0') tempo,

       trunc(((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60) segundo2,
       lpad(trunc(24008.540000 / 60 / 60), 2, '0')  || ':' ||
       lpad(trunc(24008.540000 / 60 / 100), 2, '0') || ':' ||
       lpad(trunc(((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60), 2, '0') tempo2,

       (((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60) segundo3,
       lpad(trunc(24008.540000 / 60 / 60), 2, '0')  || ':' ||
       lpad(trunc(24008.540000 / 60 / 100), 2, '0') || ':' ||
       lpad(round((((24008.540000 / 60) - trunc(24008.540000 / 60)) * 60), 2), 5, '0') tempo3       
  from dual
--------------------------------------------------------------------------------------------------
declare
  starttime number default sys.dbms_utility.get_time;
  endtime   number default 0;
  m1        number default 0;
  m2        number default 0;
begin
  dbms_lock.sleep(10);
  endtime := sys.dbms_utility.get_time;
  /* this bit returns the elapsed difference in hundreths of a second*/
  m1 := mod(((endtime - starttime) + power(2, 32)), power(2, 32));
  m2 := (endtime - starttime) / 100;
  dbms_output.put_line('Start..: ' || to_char(starttime));
  dbms_output.put_line('End....: ' || to_char(endtime));
  dbms_output.put_line('Mod1...: ' || to_char(m1));
  dbms_output.put_line('Mod2...: ' || to_char(m2));
end;
--------------------------------------------------------------------------------------------------
declare
  starttime number default sys.dbms_utility.get_time;
  endtime   number default 0;
  diftime   number default 0;
begin
  dbms_lock.sleep(10);
  endtime := sys.dbms_utility.get_time;
  diftime := (endtime - starttime) / 100;
  dbms_output.put_line('Elapsed Time: ' || diftime || ' secs');
end;
--------------------------------------------------------------------------------------------------
create or replace function f_horas(inicio date, fim date) return varchar2 is
  dias_v    number;
  horas_v   number;
  minutos_v number;
begin
  select ((trunc(fim) - trunc(inicio)) * 24) / 60 dias,
         (to_number(to_char(fim, 'hh24')) - to_number(to_char(inicio, 'hh24')))  horas,
         (abs(to_number(to_char(fim, 'mi')) - to_number(to_char(inicio, 'mi')))) minutos,
                abs(to_number(to_char(sysdate, 'ss')) -
           to_number(to_char(to_date('22/08/2012 07:34:45',
                                     'dd/mm/yyyy hh24:mi:ss'),
                             'ss'))) minutos
    into dias_v,
         horas_v,
         minutos_v
    from dual;
  return lpad(dias_v + horas_v, 3, '0') || ':' || lpad(minutos_v, 2, '0');
end;
/
--------------------------------------------------------------------------------------------------
select ((trunc(sysdate) -
       trunc(to_date('22/08/2012 07:34:45', 'dd/mm/yyyy hh24:mi:ss'))) * 24) / 60 dias,
       to_number(to_char(sysdate, 'hh24')) -
       to_number(to_char(to_date('22/08/2012 07:34:45',
                                 'dd/mm/yyyy hh24:mi:ss'),
                         'hh24')) horas,
       abs(to_number(to_char(sysdate, 'mi')) -
           to_number(to_char(to_date('22/08/2012 07:34:45',
                                     'dd/mm/yyyy hh24:mi:ss'),
                             'mi'))) minutos,
       abs(to_number(to_char(sysdate, 'ss')) -
           to_number(to_char(to_date('22/08/2012 07:34:45',
                                     'dd/mm/yyyy hh24:mi:ss'),
                             'ss'))) minutos
  from dual;
