drop table ad_luciano.tb_list;
drop table ad_luciano.tb_composition;
drop table ad_luciano.tb_item;
--------------------------------------------------------------------------------
create table ad_luciano.tb_item(
  id    number(10) primary key,
  texto varchar2(25) not null
);
--------------------------------------------------------------------------------
create table ad_luciano.tb_composition(
  id    number(10) primary key,
  texto varchar2(25) not null
);
--------------------------------------------------------------------------------
create table ad_luciano.tb_list(
  id_comp references ad_luciano.tb_composition(id) not null,
  id_item references ad_luciano.tb_item(id),
  id_non  references ad_luciano.tb_composition(id),
  id_cnt  number(5)  not null check (id_cnt > 0), 
  check (id_item is null and id_non is not null or id_item is not null and id_non is null)
);
--------------------------------------------------------------------------------
insert into ad_luciano.tb_item values (1, 'Item 1');
insert into ad_luciano.tb_item values (2, 'Item 2');
insert into ad_luciano.tb_item values (3, 'Item 3');
insert into ad_luciano.tb_item values (4, 'Item 4');
insert into ad_luciano.tb_item values (5, 'Item 5');
insert into ad_luciano.tb_item values (6, 'Item 6');

insert into ad_luciano.tb_composition values (1, 'Composição 1');
insert into ad_luciano.tb_composition values (2, 'Composição 2');
insert into ad_luciano.tb_composition values (3, 'Composição 3');
insert into ad_luciano.tb_composition values (4, 'Composição 4');
insert into ad_luciano.tb_composition values (5, 'Composição 5');
insert into ad_luciano.tb_composition values (6, 'Produção 1');
insert into ad_luciano.tb_composition values (7, 'Produção 2');
insert into ad_luciano.tb_composition values (8, 'Produção 3');

insert into ad_luciano.tb_list values (1,    4, null, 2);
insert into ad_luciano.tb_list values (1,    6, null, 3);
insert into ad_luciano.tb_list values (2,    1, null, 5);
insert into ad_luciano.tb_list values (2,    4, null, 1);
insert into ad_luciano.tb_list values (2,    5, null, 3);
insert into ad_luciano.tb_list values (3,    2, null, 2);
insert into ad_luciano.tb_list values (3, null,    1, 2);
insert into ad_luciano.tb_list values (4, null,    2, 1);
insert into ad_luciano.tb_list values (4,    3, null, 4);
insert into ad_luciano.tb_list values (4,    6, null, 1);
insert into ad_luciano.tb_list values (5, null,    3, 1);
insert into ad_luciano.tb_list values (5,    2, null, 4);
insert into ad_luciano.tb_list values (6, null,    5, 1);
insert into ad_luciano.tb_list values (6, null,    4, 1);
insert into ad_luciano.tb_list values (6,    1, null, 1);
insert into ad_luciano.tb_list values (7, null,    5, 1);
insert into ad_luciano.tb_list values (7, null,    3, 2);
insert into ad_luciano.tb_list values (8, null,    5, 1);
insert into ad_luciano.tb_list values (8,    3, null, 2);

commit;
--------------------------------------------------------------------------------
select *
  from ad_luciano.tb_list        l,
       ad_luciano.tb_item        i,
       ad_luciano.tb_composition c
 where l.id_item = i.id
   and l.id_comp  = c.id; 
--------------------------------------------------------------------------------
select substr(lpad(' ', (2 * level - 1)) || nvl(c.texto, i.texto), 1, 40) txt,
       ' [' || id_cnt || 'X' || '] ' cnt
  from ad_luciano.tb_list                 l
      left join ad_luciano.tb_item        i on l.id_item = i.id
      left join ad_luciano.tb_composition c on l.id_comp  = c.id 
start with l.id_comp = 7
connect by l.id_comp =  prior l.id_non;