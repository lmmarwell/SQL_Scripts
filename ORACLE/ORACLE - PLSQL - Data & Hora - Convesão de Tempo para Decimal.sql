select round(  to_number(sysdate - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')))                      dias,
       round(((to_number(sysdate - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440) / 60) horas,
       round(( to_number(sysdate - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440)       minutos,
       round(((to_number(sysdate - to_date('25/10/1973 07:30:45','dd/mm/yyyy hh24:mi:ss')) * 1440) - 1440) * 60) segundos
  from dual 
