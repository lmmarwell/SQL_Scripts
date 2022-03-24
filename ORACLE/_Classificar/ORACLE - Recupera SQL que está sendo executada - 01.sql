select sql.sql_id,
       sql.hash_value,
       sql.command_type,
       sql.piece,
       sql.sql_text
  from v$sqltext_with_newlines sql
 where sql.hash_value in (select sess.sql_hash_value
                            from v$session sess
                           where sess.username is not null
                             and sess.sql_hash_value <> 0)
 order by sql.sql_id,
          sql.hash_value,
          sql.command_type,
          sql.piece,
          sql.sql_text
