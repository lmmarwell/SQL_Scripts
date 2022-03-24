drop table t1;

create table t1
(
  doc long raw,
  id  number(10)
);

insert into t1
(
  id,
  doc
)
values
(
  1,
  sys.utl_raw.cast_to_raw('test to go into LONG RAW column')
);

commit;

select id, doc from t1;

select doc from t1;

select sys.utl_raw.cast_to_varchar2(doc) from t1;

declare
--  v_result varchar2(5000);
  v_result LONG raw;
begin
   select doc
   into v_result
   from t1;
   dbms_output.put_line(sys.utl_raw.cast_to_varchar2(doc));
end;

select * from v$version;

select name
  from sys.user_dependencies
 where referenced_name = 'DBMS_LOB'
union
select referenced_name
  from sys.user_dependencies
 where name = 'DBMS_LOB';

declare
  tmp  varchar2(250) := '';
  vraw raw(200) := utl_raw.cast_to_raw('ABCDEABCDEABCDE');
begin
  for i in 1 .. 15 loop
    tmp := tmp || '0x' || utl_raw.substr(vraw, i, 1) || ' ';
    dbms_output.put_line(tmp);
  end loop;
end;
