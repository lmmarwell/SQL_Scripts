-- drop table
drop table ad_luciano.ctrl_session;
-- create table
create table ad_luciano.ctrl_session
(
  sid        number,
  username   varchar2(30),
  schemaname varchar2(30),
  osuser     varchar2(30),
  machine    varchar2(64),
  module     varchar2(48),
  action     varchar2(32),
  event      varchar2(64),
  datetime   date
)
tablespace users
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 2m
    next 2m
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- select table
select * from ad_luciano.ctrl_session;
---------------------------------------------------
select vs.sid,
       vs.username,
       vs.status,
       vs.schemaname,
       vs.osuser,
       vs.machine,
       vs.module,
       vs.action,
       vs.event,
       sysdate datetime
  from v$session vs
 where vs.status = 'ACTIVE';
---------------------------------------------------
select vs.*
  from v$session vs
 where vs.username = 'SANFOM'
   and vs.status = 'ACTIVE'
---------------------------------------------------
