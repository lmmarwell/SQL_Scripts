col object_name format a25;

col process format a15;

select v.object_id,
       o.object_name,
       v.session_id,
       s.serial#,
       v.oracle_username process
  from v$locked_object v,
       dba_objects o,
       v$session s
 where v.object_id = o.object_id
   and v.session_id = s.sid;
