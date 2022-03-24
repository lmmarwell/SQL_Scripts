/*
Data Source=Banco;
User Id=Usuario;
Password=Senha;
Min Pool Size=10;
Connection Lifetime=120;
Connection Timeout=60;
Incr Pool Size=5;
Decr Pool Size=2;
*/

select *
  from dba_profiles
 where resource_name in ('IDLE_TIME', 'CONNECT_TIME');

select p.name,
       p.description,
       p.value
  from v$parameter  p
  
select *
  from v$instance
  
select *
  from v$spparameter
 where isspecified != 'FALSE';
