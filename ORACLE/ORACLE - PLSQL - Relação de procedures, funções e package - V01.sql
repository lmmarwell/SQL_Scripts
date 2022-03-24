 select up.object_type,
        up.object_name,
        up.subprogram_id,
        up.procedure_name
   from user_procedures up
--  where up.object_name like '%ARQUIVO%'
--    and up.object_type = 'PACKAGE'
  order by up.object_type,
           up.object_name,
           up.subprogram_id,
           up.procedure_name;
