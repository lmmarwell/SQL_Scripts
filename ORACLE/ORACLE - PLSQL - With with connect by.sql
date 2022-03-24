create table table_1
(
  p_name varchar2(10),
  cases  number(3)
);
 
insert into table_1 values ('James',  2);
insert into table_1 values ('Mary',   3);
insert into table_1 values ('Steve',  2);
insert into table_1 values ('Janice', 1);
commit;
 
select * from table_1;
 
create table table_2 as select p_name from table_1  where 1 = 2;
 
select * from table_2;
 
insert into table_2
  with rn as (select rownum rn
              from dual
              connect by level <= (select max(cases) from table_1)
             )
select * --p_name
  from table_1, rn
 where rn <= cases
 order by p_name;
 
select * from table_2;
