with t3(
  flag1,
  flag2,
  flag3,
  tt,
  st,
  other_data) as
  (
    select '0' flag1,
           '0' flag2,
           '0' flag3,
           current_timestamp  tt,
           sysdate  st,
           'dummy'  other_data 
      from dual 
    union all
    select case
             when cast(flag2 as int) > 0 then cast((cast(flag1 as int) + 1) as varchar2(30))
             else flag1
           end flag1,
           cast((cast(flag2 as int) + 1) as varchar2(30)) flag2,
           case
             when ((flag2 = '3') or (flag2 = '4')) then cast ((cast(flag3 as int) + 1) as varchar2(30))
             else cast(cast(flag1 as int) * cast(flag2 as int) as varchar2(30))
           end flag3,
           current_timestamp  tt,
           sysdate  st,
           'ACTUAL' other_data
      from t3
     where flag2 < 20  
  )
select *
  from t3
 where other_data != 'dummy';