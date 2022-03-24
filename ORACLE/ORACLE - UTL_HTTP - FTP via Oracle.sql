----------------------------------------------------------------------------------
CREATE OR REPLACE DIRECTORY my_docs AS '/u01/app/oracle/';
SET SERVEROUTPUT ON SIZE 1000000
@c:\ftp.pks
@c:\ftp.pkb
----------------------------------------------------------------------------------
-- Retrieve an ASCII file from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.ascii(p_conn => l_conn);
  ftp.get(p_conn      => l_conn,
          p_from_file => '/u01/app/oracle/test.txt',
          p_to_dir    => 'MY_DOCS',
          p_to_file   => 'test_get.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Send an ASCII file to a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.ascii(p_conn => l_conn);
  ftp.put(p_conn      => l_conn,
          p_from_dir  => 'MY_DOCS',
          p_from_file => 'test_get.txt',
          p_to_file   => '/u01/app/oracle/test_put.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Retrieve a binary file from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.binary(p_conn => l_conn);
  ftp.get(p_conn      => l_conn,
          p_from_file => '/u01/app/oracle/product/9.2.0.1.0/sysman/reporting/gif/jobs.gif',
          p_to_dir    => 'MY_DOCS',
          p_to_file   => 'jobs_get.gif');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Send a binary file to a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.binary(p_conn => l_conn);
  ftp.put(p_conn      => l_conn,
          p_from_dir  => 'MY_DOCS',
          p_from_file => 'jobs_get.gif',
          p_to_file   => '/u01/app/oracle/jobs_put.gif');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Get a directory listing from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
  l_list  ftp.t_string_table;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.list(p_conn   => l_conn,
           p_dir   => '/u01/app/oracle',
           p_list  => l_list);
  ftp.logout(l_conn);
  
  IF l_list.COUNT > 0 THEN
    FOR i IN l_list.first .. l_list.last LOOP
      DBMS_OUTPUT.put_line(i || ': ' || l_list(i));
    END LOOP;
  END IF;
END;
/
----------------------------------------------------------------------------------
-- Get a directory listing (file names only) from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
  l_list  ftp.t_string_table;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.nlst(p_conn   => l_conn,
           p_dir   => '/u01/app/oracle',
           p_list  => l_list);
  ftp.logout(l_conn);
  
  IF l_list.COUNT > 0 THEN
    FOR i IN l_list.first .. l_list.last LOOP
      DBMS_OUTPUT.put_line(i || ': ' || l_list(i));
    END LOOP;
  END IF;
END;
/
----------------------------------------------------------------------------------
-- Rename a file on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.rename(p_conn => l_conn,
             p_from => '/u01/app/oracle/dba/shutdown',
             p_to   => '/u01/app/oracle/dba/shutdown.old');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Delete a file on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.delete(p_conn => l_conn,
             p_file => '/u01/app/oracle/dba/temp.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Create a directory on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.mkdir(p_conn => l_conn,
            p_dir => '/u01/app/oracle/test');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Remove a directory from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.rmdir(p_conn => l_conn,
            p_dir  => '/u01/app/oracle/test');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
DECLARE
  l_acl_name    VARCHAR2(30) := 'utl_tcp.xml';
  l_ftp_server  VARCHAR2(20) := '192.168.2.131';
  l_username    VARCHAR2(30) := 'TEST';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => l_acl_name, 
    description  => 'Allow connections using UTL_TCP',
    principal    => l_username,
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);

  COMMIT;

  DBMS_NETWORK_ACL_ADMIN.add_privilege ( 
    acl         => l_acl_name, 
    principal   => l_username,
    is_grant    => FALSE, 
    privilege   => 'connect', 
    position    => NULL, 
    start_date  => NULL,
    end_date    => NULL);

  COMMIT;

  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => l_acl_name,
    host        => l_ftp_server, 
    lower_port  => NULL,
    upper_port  => NULL);

  COMMIT;
END;
/
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
CREATE OR REPLACE DIRECTORY my_docs AS '/u01/app/oracle/';
SET SERVEROUTPUT ON SIZE 1000000
@c:\ftp.pks
@c:\ftp.pkb
----------------------------------------------------------------------------------
-- Retrieve an ASCII file from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.ascii(p_conn => l_conn);
  ftp.get(p_conn      => l_conn,
          p_from_file => '/u01/app/oracle/test.txt',
          p_to_dir    => 'MY_DOCS',
          p_to_file   => 'test_get.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Send an ASCII file to a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.ascii(p_conn => l_conn);
  ftp.put(p_conn      => l_conn,
          p_from_dir  => 'MY_DOCS',
          p_from_file => 'test_get.txt',
          p_to_file   => '/u01/app/oracle/test_put.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Retrieve a binary file from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.binary(p_conn => l_conn);
  ftp.get(p_conn      => l_conn,
          p_from_file => '/u01/app/oracle/product/9.2.0.1.0/sysman/reporting/gif/jobs.gif',
          p_to_dir    => 'MY_DOCS',
          p_to_file   => 'jobs_get.gif');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Send a binary file to a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.binary(p_conn => l_conn);
  ftp.put(p_conn      => l_conn,
          p_from_dir  => 'MY_DOCS',
          p_from_file => 'jobs_get.gif',
          p_to_file   => '/u01/app/oracle/jobs_put.gif');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Get a directory listing from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
  l_list  ftp.t_string_table;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.list(p_conn   => l_conn,
           p_dir   => '/u01/app/oracle',
           p_list  => l_list);
  ftp.logout(l_conn);
  
  IF l_list.COUNT > 0 THEN
    FOR i IN l_list.first .. l_list.last LOOP
      DBMS_OUTPUT.put_line(i || ': ' || l_list(i));
    END LOOP;
  END IF;
END;
/
----------------------------------------------------------------------------------
-- Get a directory listing (file names only) from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
  l_list  ftp.t_string_table;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.nlst(p_conn   => l_conn,
           p_dir   => '/u01/app/oracle',
           p_list  => l_list);
  ftp.logout(l_conn);
  
  IF l_list.COUNT > 0 THEN
    FOR i IN l_list.first .. l_list.last LOOP
      DBMS_OUTPUT.put_line(i || ': ' || l_list(i));
    END LOOP;
  END IF;
END;
/
----------------------------------------------------------------------------------
-- Rename a file on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.rename(p_conn => l_conn,
             p_from => '/u01/app/oracle/dba/shutdown',
             p_to   => '/u01/app/oracle/dba/shutdown.old');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Delete a file on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.delete(p_conn => l_conn,
             p_file => '/u01/app/oracle/dba/temp.txt');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Create a directory on a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.mkdir(p_conn => l_conn,
            p_dir => '/u01/app/oracle/test');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------
-- Remove a directory from a remote FTP server.
DECLARE
  l_conn  UTL_TCP.connection;
BEGIN
  l_conn := ftp.login('ftp.company.com', '21', 'ftpuser', 'ftppassword');
  ftp.rmdir(p_conn => l_conn,
            p_dir  => '/u01/app/oracle/test');
  ftp.logout(l_conn);
END;
/
----------------------------------------------------------------------------------