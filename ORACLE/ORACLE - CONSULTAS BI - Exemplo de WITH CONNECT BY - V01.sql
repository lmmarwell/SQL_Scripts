--------------------------------------------------------------------------------
drop table ad_luciano.tb_connect_by;
--------------------------------------------------------------------------------
create table ad_luciano.tb_connect_by (
  id         number(10) not null,
  id_parent  number(10)
);
--------------------------------------------------------------------------------
alter table ad_luciano.tb_connect_by add constraint pk_connect_by primary key (id);
alter table ad_luciano.tb_connect_by add constraint fk_connect_by foreign key (id_parent) references ad_luciano.tb_connect_by(id);
alter table ad_luciano.tb_connect_by add constraint uk_connect_by unique(id, id_parent);
--------------------------------------------------------------------------------
insert into ad_luciano.tb_connect_by values(00, null);

insert into ad_luciano.tb_connect_by values(01, 00);
insert into ad_luciano.tb_connect_by values(02, 00);
insert into ad_luciano.tb_connect_by values(03, 00);
insert into ad_luciano.tb_connect_by values(04, 00);
insert into ad_luciano.tb_connect_by values(05, 00);
insert into ad_luciano.tb_connect_by values(06, 00);
insert into ad_luciano.tb_connect_by values(07, 00);
insert into ad_luciano.tb_connect_by values(08, 00);
insert into ad_luciano.tb_connect_by values(09, 00);

insert into ad_luciano.tb_connect_by values(10, 01);
insert into ad_luciano.tb_connect_by values(11, 01);
insert into ad_luciano.tb_connect_by values(12, 01);
insert into ad_luciano.tb_connect_by values(13, 01);
insert into ad_luciano.tb_connect_by values(14, 01);
insert into ad_luciano.tb_connect_by values(15, 01);
insert into ad_luciano.tb_connect_by values(16, 01);
insert into ad_luciano.tb_connect_by values(17, 01);
insert into ad_luciano.tb_connect_by values(18, 01);
insert into ad_luciano.tb_connect_by values(19, 01);

insert into ad_luciano.tb_connect_by values(20, 10);
insert into ad_luciano.tb_connect_by values(21, 10);
insert into ad_luciano.tb_connect_by values(22, 10);
insert into ad_luciano.tb_connect_by values(23, 10);
insert into ad_luciano.tb_connect_by values(24, 10);
insert into ad_luciano.tb_connect_by values(25, 10);
insert into ad_luciano.tb_connect_by values(26, 10);
insert into ad_luciano.tb_connect_by values(27, 10);
insert into ad_luciano.tb_connect_by values(28, 10);
insert into ad_luciano.tb_connect_by values(29, 10);

insert into ad_luciano.tb_connect_by values(30, 20);
insert into ad_luciano.tb_connect_by values(31, 20);
insert into ad_luciano.tb_connect_by values(32, 20);
insert into ad_luciano.tb_connect_by values(33, 20);
insert into ad_luciano.tb_connect_by values(34, 20);
insert into ad_luciano.tb_connect_by values(35, 20);
insert into ad_luciano.tb_connect_by values(36, 20);
insert into ad_luciano.tb_connect_by values(37, 20);
insert into ad_luciano.tb_connect_by values(38, 20);
insert into ad_luciano.tb_connect_by values(39, 20);

insert into ad_luciano.tb_connect_by values(40, 01);
insert into ad_luciano.tb_connect_by values(41, 01);
insert into ad_luciano.tb_connect_by values(42, 01);
insert into ad_luciano.tb_connect_by values(43, 01);
insert into ad_luciano.tb_connect_by values(44, 01);
insert into ad_luciano.tb_connect_by values(45, 01);
insert into ad_luciano.tb_connect_by values(46, 01);
insert into ad_luciano.tb_connect_by values(47, 01);
insert into ad_luciano.tb_connect_by values(48, 01);
insert into ad_luciano.tb_connect_by values(49, 01);

insert into ad_luciano.tb_connect_by values(50, 05);
insert into ad_luciano.tb_connect_by values(51, 05);
insert into ad_luciano.tb_connect_by values(52, 05);
insert into ad_luciano.tb_connect_by values(53, 05);
insert into ad_luciano.tb_connect_by values(54, 50);
insert into ad_luciano.tb_connect_by values(55, 50);
insert into ad_luciano.tb_connect_by values(56, 50);
insert into ad_luciano.tb_connect_by values(57, 50);
insert into ad_luciano.tb_connect_by values(58, 55);
insert into ad_luciano.tb_connect_by values(59, 58);

insert into ad_luciano.tb_connect_by values(60, 08);
insert into ad_luciano.tb_connect_by values(61, 08);
insert into ad_luciano.tb_connect_by values(62, 08);
insert into ad_luciano.tb_connect_by values(63, 08);
insert into ad_luciano.tb_connect_by values(64, 08);
insert into ad_luciano.tb_connect_by values(65, 09);
insert into ad_luciano.tb_connect_by values(66, 09);
insert into ad_luciano.tb_connect_by values(67, 09);
insert into ad_luciano.tb_connect_by values(68, 09);
insert into ad_luciano.tb_connect_by values(69, 09);

commit;
--------------------------------------------------------------------------------
select level,
       id,
       id_parent
  from ad_luciano.tb_connect_by 
  start with id > 0
  connect by prior id = id_parent;
--------------------------------------------------------------------------------
select (lpad(' ', (3 * (level -1 ))) || trim(to_char(id_parent, '09')) || '.' || trim(to_char(id, '09'))) nivel,
--select (lpad(' ', (2 * (level -1 ))) || trim(to_char(id_parent, '09')) || trim(to_char(id, '09'))) nivel,
       level
  from ad_luciano.tb_connect_by 
--  start with id is null
  start with id_parent is null
  connect by prior id = id_parent;
--------------------------------------------------------------------------------  
select level level_,
       id,
       id_parent,
       substr((lpad(' ', (3 * (level -1 ))) || trim(to_char(id_parent, '09')) || '.' || trim(to_char(id, '09'))), 2, 30) tree
  from ad_luciano.tb_connect_by 
  start with id_parent is null
  connect by prior id = id_parent;
--------------------------------------------------------------------------------  