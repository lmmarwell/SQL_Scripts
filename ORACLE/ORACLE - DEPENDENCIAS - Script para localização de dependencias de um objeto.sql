--------------------------------------------------------------------------------
-- Drop todos os objetos
--------------------------------------------------------------------------------
drop procedure dep_tree_fill;
drop sequence dep_tree_seq;
drop table dep_tree_temptab;
drop view dep_tree;
drop view dep_i_tree;
/
--------------------------------------------------------------------------------
-- Cria os objetos do do processo
--------------------------------------------------------------------------------
create table fisc33.dep_tree_temptab
(
  object_id            number(10),
  referenced_object_id number(10),
  nest_level           number(10),
  seq                  number(10)
);
create or replace view fisc33.dep_tree(seq, nested_level, type, schema, dependency)
as
select d.seq,
       d.nest_level,
       o.object_type,
       o.owner,
       o.object_name      
  from fisc33.dep_tree_temptab d,
       sys.all_objects o
 where d.object_id = o.object_id(+)
 order by d.seq;
/   
create or replace view fisc33.dep_i_tree(dep_endencies)
as
select lpad(' ', 3 * (max(nested_level))) ||
       max(nvl(type, '<no permission>') || ' ' || schema ||
           decode(type, null, '', '.') || dependency)
  from fisc33.dep_tree
 group by seq;
/
create sequence fisc33.dep_tree_seq minvalue 1 maxvalue 9999999999 start with 1 increment by 1 cache 64;
/
create or replace procedure dep_tree_fill(type char, schema char, name char) is
  obj_id number;
begin
  delete from fisc33.dep_tree_temptab;
  commit;
  select object_id
    into obj_id
    from sys.all_objects
   where owner = upper(fisc33.dep_tree_fill.schema)
     and object_name = upper(fisc33.dep_tree_fill.name)
     and object_type = upper(fisc33.dep_tree_fill.type);
  insert into fisc33.dep_tree_temptab values (obj_id, 0, 0, fisc33.dep_tree_seq.nextval);
  commit;
  insert into fisc33.dep_tree_temptab
    select object_id,
           referenced_object_id,
           level,
           fisc33.dep_tree_seq.nextval
      from sys.public_dependency
    connect by prior object_id = referenced_object_id
     start with referenced_object_id = fisc33.dep_tree_fill.obj_id;
  commit;
exception
  when no_data_found then
    raise_application_error(-20000,
                            'oru-10013: ' || type || ' ' || schema || '.' || name ||
                            ' was not found.');
end;
/
grant execute on fisc33.dep_tree_fill to public;
grant select on fisc33.dep_tree to public;
grant select on fisc33.dep_i_tree to public;
