create or replace view sys.user_constraints
(owner, constraint_name, constraint_type, table_name, search_condition, r_owner, r_constraint_name, delete_rule, status, deferrable, deferred, validated, generated, bad, rely, last_change, index_owner, index_name, invalid, view_related)
as
select ou.name,
       oc.name,
       decode(c.type#, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V', 6, 'O', 7,'C', '?'),
       o.name,
       c.condition,
       ru.name,
       rc.name,
       decode(c.type#, 4,
              decode(c.refact, 1, 'CASCADE', 2, 'SET NULL', 'NO ACTION'),
              NULL),
       decode(c.type#, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED', 'ENABLED')),
       decode(bitand(c.defer, 1), 1, 'DEFERRABLE', 'NOT DEFERRABLE'),
       decode(bitand(c.defer, 2), 2, 'DEFERRED', 'IMMEDIATE'),
       decode(bitand(c.defer, 4), 4, 'VALIDATED', 'NOT VALIDATED'),
       decode(bitand(c.defer, 8), 8, 'GENERATED NAME', 'USER NAME'),
       decode(bitand(c.defer,16),16, 'BAD', null),
       decode(bitand(c.defer,32),32, 'RELY', null),
       c.mtime,
       decode(c.type#, 2, ui.name, 3, ui.name, null),
       decode(c.type#, 2, oi.name, 3, oi.name, null),
       decode(bitand(c.defer, 256), 256,
              decode(c.type#, 4,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)
                                or ro.status in (3, 5)) then 'INVALID'
                          else null end,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)) then 'INVALID'
                          else null end
                    ),
              null),
       decode(bitand(c.defer, 256), 256, 'DEPEND ON VIEW', null)
from sys.con$ oc,
     sys.con$ rc,
     sys.user$ ou,
     sys.user$ ru,
     sys.obj$ ro,
     sys.obj$ o,
     sys.cdef$ c,
     sys.obj$ oi,
     sys.user$ ui
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.rcon# = rc.con#(+)
  and c.enabled = oi.obj#(+)
  and oi.owner# = ui.user#(+)
  and rc.owner# = ru.user#(+)
  and c.robj# = ro.obj#(+)
  and o.owner# = userenv('SCHEMAID')
  and c.type# != 8
  and c.type# != 12       /* don't include log groups */;
comment on column SYS.USER_CONSTRAINTS.OWNER is 'Owner of the table';
comment on column SYS.USER_CONSTRAINTS.CONSTRAINT_NAME is 'Name associated with constraint definition';
comment on column SYS.USER_CONSTRAINTS.CONSTRAINT_TYPE is 'Type of constraint definition';
comment on column SYS.USER_CONSTRAINTS.TABLE_NAME is 'Name associated with table with constraint definition';
comment on column SYS.USER_CONSTRAINTS.SEARCH_CONDITION is 'Text of search condition for table check';
comment on column SYS.USER_CONSTRAINTS.R_OWNER is 'Owner of table used in referential constraint';
comment on column SYS.USER_CONSTRAINTS.R_CONSTRAINT_NAME is 'Name of unique constraint definition for referenced table';
comment on column SYS.USER_CONSTRAINTS.DELETE_RULE is 'The delete rule for a referential constraint';
comment on column SYS.USER_CONSTRAINTS.STATUS is 'Enforcement status of constraint -  ENABLED or DISABLED';
comment on column SYS.USER_CONSTRAINTS.DEFERRABLE is 'Is the constraint deferrable - DEFERRABLE or NOT DEFERRABLE';
comment on column SYS.USER_CONSTRAINTS.DEFERRED is 'Is the constraint deferred by default -  DEFERRED or IMMEDIATE';
comment on column SYS.USER_CONSTRAINTS.VALIDATED is 'Was this constraint system validated? -  VALIDATED or NOT VALIDATED';
comment on column SYS.USER_CONSTRAINTS.GENERATED is 'Was the constraint name system generated? -  GENERATED NAME or USER NAME';
comment on column SYS.USER_CONSTRAINTS.BAD is 'Creating this constraint should give ORA-02436.  Rewrite it before 2000 AD.';
comment on column SYS.USER_CONSTRAINTS.RELY is 'If set, this flag will be used in optimizer';
comment on column SYS.USER_CONSTRAINTS.LAST_CHANGE is 'The date when this column was last enabled or disabled';
comment on column SYS.USER_CONSTRAINTS.INDEX_OWNER is 'The owner of the index used by the constraint';
comment on column SYS.USER_CONSTRAINTS.INDEX_NAME is 'The index used by the constraint';
