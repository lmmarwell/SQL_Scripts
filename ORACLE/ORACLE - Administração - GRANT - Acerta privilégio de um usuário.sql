select *
  from (
        select 'grant '|| privilege ||' to '|| grantee ||';'
          from dba_sys_privs
         where grantee in ('SAD','SIF', 'SACS')
         union all
        select 'grant '|| privilege ||' on '|| grantor ||'.'|| table_name ||' to '|| grantee ||';'
          from dba_tab_privs
         where grantee in ('SAD','SIF', 'SACS')
         union all
        select 'grant '|| granted_role ||' to '|| grantee ||';'
          from dba_role_privs
         where grantee in ('SAD','SIF', 'SACS')
       );

begin
   for tab in (select owner,
                      object_name,
                      object_type
                 from sys.all_objects
                where owner in ('SACS', 'SIF')
                  and object_type in ('SEQUENCE', 'TABLE')) loop
      execute immediate 'grant all on '|| tab.owner || '.' || tab.object_name ||' to SAD';
   end loop;
end;