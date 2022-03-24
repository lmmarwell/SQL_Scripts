/*

carloshgiraldoz.blogspot.com.br/2013/12/configurar-correo-con-acl-oracle-11g.html
https://docs.oracle.com/cd/B28359_01/appdev.111/b28419/d_networkacl_adm.htm#BABJHGBE
https://docs.oracle.com/cd/B28359_01/appdev.111/b28419/d_networkacl_adm.htm#CHDJFJFF
https://docs.oracle.com/database/121/ARPLS/d_networkacl_adm.htm#ARPLS67227
psoug.org/reference/dbms_network_acl_admin.html
www.haciendoti.com/oracle-acl-lista-de-control-de-acceso/
www.morganslibrary.org/reference/pkgs/dbms_network_acl_admin.html
www.oracleflash.com/36/Oracle-11g-Access-Control-List-for-External-Network-Services.html
www.haciendoti.com/oracle-acl-lista-de-control-de-acceso/
https://docs.oracle.com/database/121/ARPLS/d_networkacl_adm.htm#ARPLS67227
www.morganslibrary.org/reference/pkgs/dbms_network_acl_admin.html
www.oracleflash.com/36/Oracle-11g-Access-Control-List-for-External-Network-Services.html
psoug.org/reference/dbms_network_acl_admin.html

*/

select *
  from sys.dba_tab_privs
 where table_name like 'UTL%'
   and owner = 'SYS'
   and grantee = 'PUBLIC'
 order by 2, 3, 1;


select distinct
       object_name || '.' || procedure_name objeto,
       'dbms_network_acl_admin.create_acl(acl =>''' || lower(object_name || '.' || procedure_name) || ''', description => ''allow mail to be send'', principal => ''AD_LUCIANO'', is_grant => true, privilege => ''connect'');' "connect", 
       'dbms_network_acl_admin.add_privilege(acl =>''' || lower(object_name || '.' || procedure_name) || ''', principal => ''AD_LUCIANO'', is_grant => true, privilege => ''resolve'');' "resolve"
  from sys.all_procedures
 where object_type = 'PACKAGE'
   and object_name like '%HTTP%'
   and procedure_name is not null
   and owner = 'SYS'
 order by 1;

select * from sys.xds_acl;

begin
  sys.dbms_network_acl_admin.drop_acl(acl =>'gestao_fsa_utl_tcp.xml');
  sys.dbms_network_acl_admin.drop_acl(acl =>'gestao_fsa_utl_http.xml');
  sys.dbms_network_acl_admin.drop_acl(acl =>'gestao_fsa_utl_smtp.xml');
  sys.dbms_network_acl_admin.drop_acl(acl =>'gestao_fsa_utl_mail.xml');
  commit;
end;

begin

  sys.dbms_network_acl_admin.create_acl(acl =>'gestao_fsa_utl_tcp.xml',  description => 'Gestão FSA - UTL_TCP - Acesso ao  pacote de controle UTL_TCP',  principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_tcp.xml',  principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_tcp.xml',  principal => 'AD_LUCIANO', is_grant => true, privilege => 'resolve');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_tcp.xml',  host => '10.1.*');

  sys.dbms_network_acl_admin.create_acl(acl =>'gestao_fsa_utl_http.xml', description => 'Gestão FSA - UTL_HTTP - Acesso ao pacote de controle UTL_HTTP', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_http.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_http.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'resolve');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_http.xml', host => '10.1.124.49');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_http.xml', host => '10.1.124.211');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_http.xml', host => '*');

  sys.dbms_network_acl_admin.create_acl(acl =>'gestao_fsa_utl_smtp.xml', description => 'Gestão FSA - UTL_SMPT - Acesso ao pacote de controle UTL_SMPT', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_smtp.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_smtp.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'resolve');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_smtp.xml', host => '10.1.124.206');

  sys.dbms_network_acl_admin.create_acl(acl =>'gestao_fsa_utl_mail.xml', description => 'Gestão FSA - UTL_MAIL - Acesso ao pacote de controle UTL_MAIL', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_mail.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'connect');
  sys.dbms_network_acl_admin.add_privilege(acl =>'gestao_fsa_utl_mail.xml', principal => 'AD_LUCIANO', is_grant => true, privilege => 'resolve');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_mail.xml', host => 'email.ancinerj.gov.br');
  sys.dbms_network_acl_admin.assign_acl(acl =>'gestao_fsa_utl_mail.xml', host => 'correio.ancine.gov.br');

  commit;
end;


select * from sys.xds_acl;
select * from sys.user_network_acl_privileges;
select * from sys.dba_wallet_acls;
select * from sys.dba_network_acl_privileges;
select * from sys.dba_network_acls;


select decode(dbms_network_acl_admin.check_privilege('utl_http.xml', 'AD_LUCIANO', 'resolve'), 1, 'GRANTED', 0, 'DENIED', null) privilege from dual;
select decode(dbms_network_acl_admin.check_privilege('utl_http.xml', 'AD_LUCIANO', 'connect'), 1, 'GRANTED', 0, 'DENIED', null) privilege from dual;

select acl,
       host,
       decode(dbms_network_acl_admin.check_privilege_aclid(aclid, 'AD_LUCIANO', 'connect'), 1, 'GRANTED', 0, 'DENIED', null) prv_connect,
       decode(dbms_network_acl_admin.check_privilege_aclid(aclid, 'AD_LUCIANO', 'resolve'), 1, 'GRANTED', 0, 'DENIED', null) prv_resolve
  from dba_network_acls;

select *
  from sys.all_objects
 where object_name like '%ACL%'
   and owner       = 'SYS'
   and object_type = 'VIEW';
 
select *
  from sys.all_objects
 where object_name like '%DBMS_NETWORK_ACL_ADMIN%';

select *
  from sys.all_procedures
 where object_type = 'PACKAGE'
   and object_name like '%DBMS_NETWORK_ACL_ADMIN%'
   and procedure_name is not null
   and owner = 'SYS';

select * from dict where table_name like '%UTL%';

declare
  vresult clob;
  purl    varchar2(1000) default 'http://sad2.ancine.gov.br/sad-core-servicos/localizacao/pais/';
begin
  vresult := replace(utl_http.request(purl),chr(10),' ');
  dbms_output.put_line(vresult);
end;
--------------------------------------------------------------------------------