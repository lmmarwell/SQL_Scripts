select *
  from sys.all_tables t
 where t.table_name like 'EMITENTE_VIP_%'
 order by t.owner,
          t.table_name;

  
select *
  from dict
 where table_name like 'R%PRI%'
 
select rtp.*
  from sys.role_tab_privs rtp
 where rtp.table_name like 'EMI%'
--   and rtp.role = 'PUBLIC'
   and rtp.owner = 'S5B'
 order by rtp.role,
          rtp.owner,
          rtp.table_name,
          rtp.privilege;
          
select *
  from sys.role_role_privs

select *
  from sys.role_sys_privs


