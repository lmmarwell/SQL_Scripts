select to_char(to_timestamp('03/02/2011 12:40:08.921616', 'dd/mm/yyyy hh24:mi:ss.ff') -
               to_timestamp('03/02/2011 12:40:07.921616', 'dd/mm/yyyy hh24:mi:ss.ff'),
               'ffffff') usando_to_char,
       extract(second from to_timestamp('03/02/2011 12:40:08.921616', 'dd/mm/yyyy hh24:mi:ss.ff') -
                           to_timestamp('03/02/2011 12:40:07.921616', 'dd/mm/yyyy hh24:mi:ss.ff')
              ) *1000 udando_extract
  from dual

select to_char(to_timestamp('03/02/2011 12:40:08.921616', 'dd/mm/yyyy hh24:mi:ss.ff') -
               to_timestamp('03/02/2011 12:40:07.811505', 'dd/mm/yyyy hh24:mi:ss.ff'),
               'ffffff') usando_to_char,,,
       extract(second from to_timestamp('03/02/2011 12:40:08.921616', 'dd/mm/yyyy hh24:mi:ss.ff') -
                           to_timestamp('03/02/2011 12:40:07.811505', 'dd/mm/yyyy hh24:mi:ss.ff')
              ) * 1000 udando_extract
  from dual
