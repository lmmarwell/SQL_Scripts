select * from sys.dba_tables

-- Usando a SYS.DBA_TAB_COLUMNS
select dtc.column_id,
       dtc.column_name,
			 dtc.data_type,
			 dtc.data_length,
			 dtc.data_precision
  from sys.dba_tab_columns dtc
 where dtc.table_name = 'SYN_PRCGER_IMPRESSAO'
 order by dtc.column_id

-- Usando a SYS.USER_TAB_COLUMNS
select utc.column_id,
       utc.column_name,
			 utc.data_type,
			 utc.data_length,
			 utc.data_precision
  from sys.user_tab_columns utc
 where utc.table_name = 'SYN_PRCGER_IMPRESSAO'
 order by utc.column_id
 
--------------------------------------------------------------------------------
set serveroutput on 
-- the following urls illustrate the use of this procedure,
-- but these pages do not actually exist. to test, substitute
-- urls from your own web server.
exec show_url('http://www.oracle.com/no-such-page.html');
exec show_url('http://www.oracle.com/protected-page.html');
exec show_url('http://www.oracle.com/protected-page.html', 'scott', 'tiger');


declare
   url      varchar2 (32767);
   username varchar2 (32767);
   password varchar2 (32767);
begin
   url      := 'http://www.oracle.com/protected-page.html';
   username := 'scott';
   password := 'tiger';
   fisc33.show_url(url, username, password);
   commit;
end;