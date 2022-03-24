Select object_name || ' (' || object_type || ')' From user_objects Where status = 'INVALID';
Select trigger_name || ' (' || table_name || ')' From user_triggers Where status = 'DISABLED';
Select constraint_name || ' (' || table_name || ')' From user_constraints Where status = 'DISABLED';
