--------------------------------------------------------------------------------
select to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss') data_inicial,
       to_date('23/12/2016 10:15:00','dd/mm/yyyy hh24:mi:ss') data_final,
       (to_number(to_date('23/12/2016 10:15:00','dd/mm/yyyy hh24:mi:ss') - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')))                        dias,
       (((to_number(to_date('23/12/2016 10:15:00','dd/mm/yyyy hh24:mi:ss') - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440) / 60) horas,
       (( to_number(to_date('23/12/2016 10:15:00','dd/mm/yyyy hh24:mi:ss') - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440)       minutos,
       (((to_number(to_date('23/12/2016 10:15:00','dd/mm/yyyy hh24:mi:ss') - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440) * 60) segundos
  from dual;
--------------------------------------------------------------------------------
declare
-- Total de Segundo por Ano
--  tempo    number(38) default 31535999; 
--  tempo    number(38) default 31536000;
--  tempo    number(38) default 31536001;
  tempo    number(38) default 1362018621;

-- Constantes de multiplicação de tempo
  t_segundos constant number default   1;
  t_minutos  constant number default  60;
  t_horas    constant number default  60 * 60;
  t_dias     constant number default  24 * 60 * 60;
  t_anos     constant number default 365 * 24 * 60 * 60;

-- Variaveis para calculo de tempo fracionado
  anos     number default 0;
  dias     number default 0;
  horas    number default 0;
  minutos  number default 0;
  segundos number default 0;

-- Variavel de retorno
  retorno  varchar2(100) default null;
begin
  -- Reseta o buffer de output
  sys.dbms_output.disable;
  sys.dbms_output.enable;
  
  -- Efeuta os calculos de tempo fracionado
  anos     := trunc(tempo / t_anos);
  dias     := trunc(mod(tempo, t_anos) / t_dias);
  horas    := trunc(mod(mod(tempo, t_anos), t_dias) / t_horas);
  minutos  := trunc(mod(mod(mod(tempo, t_anos), t_dias), t_horas) / t_minutos);
  segundos := trunc(mod(mod(mod(mod(tempo, t_anos), t_dias), t_horas), t_minutos) / t_segundos);
  
  -- COncatena o resultado
  retorno  := lpad(anos,     6, '0') || ':' ||
              lpad(dias,     3, '0') || ':' ||
              lpad(horas,    2, '0') || ':' ||
              lpad(minutos,  2, '0') || ':' ||
              lpad(segundos, 2, '0');
  
  -- Imprime o reultado
  sys.dbms_output.put_line(retorno);
  
end;