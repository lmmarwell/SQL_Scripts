   select up.object_type,
          up.object_name,
          up.subprogram_id,
          up.procedure_name
     from user_procedures up
    where up.object_name like '%L%'
      and up.object_type = 'PROCEDURE'
 order by up.object_type,
          up.object_name,
          up.subprogram_id,
          up.procedure_name

		  
   select up.object_type,
          up.object_name,
          up.subprogram_id,
          up.procedure_name
     from all_procedures up
--    where up.object_name like '%L%'
--      and up.object_type = 'PROCEDURE'
 order by up.object_type,
          up.object_name,
          up.subprogram_id,
          up.procedure_name
