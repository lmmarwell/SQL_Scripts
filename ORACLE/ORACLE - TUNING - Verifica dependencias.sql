SET ECHO off 
REM NAME: TFSDEPND>SQL 
REM USAGE:"@path/tfsdepnd" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    DBA privs 
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Sambavisa Chebrolu 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    The script below generates a hierarchical list of referring  
REM    and referenced tables in any Oracle schema.  
REM 
REM    The SQL script generates a hierarchical list of tables with  
REM    a level number (tables that are linked with foreign key 
REM    constraints) from any Oracle schema. The list is useful in  
REM    identifying the 'order of tables,' while loading data, 
REM    dropping tables, or deleting rows from tables.  
REM 
REM    An example output spool file 'level_tree.lis' looks like this:   
REM 
REM    FORMAT: schema.table_name(level number)  
REM  
REM    schema1.table_three(4)     : table_three is at level 4 
REM    -   schema1.table_two(3)   : table_three references table_two 
REM    -   schema1.table_one(2)   : table_two references table_one 
REM    -   schema2.table_five(1): table_one references table_five in schema2 
REM    - schema1.table_four(1)  : table_three references table_four 
REM 
REM     
REM    The script collects referential integrity constraints data from  
REM    the data dictionary tables, creates and populates temporary   
REM    tables and prints the hierarchical table list.  
REM ------------------------------------------------------------------------ 
REM EXAMPLE: 
REM    SYSTEM.CODE_VALUES(1) 
REM    -  SYSTEM.CODE_TYPES() 
REM  ----------------------- 
REM    SYSTEM.CUSTOMER(1) 
REM    -  SYSTEM.DIVISION() 
REM    ----------------------- 
REM    SYSTEM.CUSTOMER_ADDRESS(1) 
REM    -  SYSTEM.CUSTOMER() 
REM    -    SYSTEM.DIVISION() 
REM    ----------------------- 
REM SYSTEM.CUSTOMER_PHONE(1) 
REM    -  SYSTEM.CUSTOMER_ADDRESS() 
REM    -    SYSTEM.CUSTOMER() 
REM    -      SYSTEM.DIVISION() 
REM    ----------------------- 
REM  SYSTEM.DEF$_CALLDEST(1) 
REM    -  SYSTEM.DEF$_CALL() 
REM    -  SYSTEM.DEF$_DESTINATION() 
REM    ----------------------- 
REM    SYSTEM.DIVISION_REGION(1) 
REM  -  SYSTEM.DIVISION() 
REM    ----------------------- 
REM  
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
 
--  
--  Create temporary tables, collecting data from Dictionary tables  
--  -----------------------------------------------------------------  
set termout off  
create table parent_child_tab as  
  (select x.p_level,  
          p.table_name parent_table_name,   
   p.owner p_owner,  
          x.c_level,  
          c.table_name child_table_name,  
          c.owner c_owner  
     from user_constraints p, user_constraints c,   
          (select 1 p_level, 1 c_level from dual) x  
    where p.constraint_type IN ('P','U') AND  
          c.constraint_type = 'R' AND  
          p.constraint_name = c.r_constraint_name  )  
/  
--  Collect data if the referenced tables are in another schema.  
-- -------------------------------------------------------------  
create table parent_child_temp_tab as  
  (select x.p_level,   
   a.table_name parent_table_name,  
          c.r_owner p_owner,  
          x.c_level,  
          c.table_name child_table_name,  
          c.owner c_owner  
  from user_constraints c, all_constraints a,  
          (select 1 p_level, 1 c_level from dual) x  
    where c.owner <> c.r_owner and  
          c.r_owner = a.owner and  
          c.r_constraint_name = a.constraint_name )  
/  
insert into parent_child_tab   
                ( p_level, parent_table_name, p_owner,  
            c_level, child_table_name , c_owner)  
          (select p_level, parent_table_name, p_owner,  
                  c_level, child_table_name , c_owner  
             from parent_child_temp_tab )  
/  
create table level_tab  
  ( table_name     varchar2(30),  
    level_number   number(02)  )  
/  
-- ----------------------------------------------------------------  
--  The following pl/sql block will populate the 'level_tab' table  
--  with 'table name' and 'level number'.  
--  At the end it updates 'parent_child_tab' with level numbers.  
-- ----------------------------------------------------------------  
--  
declare  
   dummy_val            char(1);  
   level_num            number(02);  
   total_levels     number(02);  
   tab_name             varchar2(30);  
   child_tab_name varchar2(30);  
--  
   cursor get_child_tab_name(pk1 number) is  
     select distinct child_table_name  
       from parent_child_tab  
      where parent_table_name in (select table_name  
                                    from level_tab  
                                   where level_number = pk1 ) ;  
--  
   cursor delete_duplicates(pk2 number) is  
     select table_name  
       from level_tab  
      where level_number = pk2 ;  
--  
begin  
-- -------------------------------------------------------  
--  Insert all Master table names with out any foreign key  
--  definition, into 'level_tab' table.  
-- -------------------------------------------------------  
  insert into level_tab  
    (select distinct parent_table_name, 1  
       from parent_child_tab  
       where parent_table_name not in   
        (select child_table_name from parent_child_tab) ) ;  
   commit;  
-- ------------------------------------------------------------  
--  Identify all tables with foreign key definition, calculate  
--  level number and insert 'table name', 'level number'   
--  into 'level_tab' table.  
-- ------------------------------------------------------------  
  level_num := 1;  
  <>  
  loop  
     open get_child_tab_name(level_num);  
     fetch get_child_tab_name into child_tab_name;  /* first record */  
     if get_child_tab_name%notfound then  
       total_levels := level_num;  
       --  'total_levels' variable gives highest depth value in the Schema    
       close get_child_tab_name;  
       exit outer_loop;  
     else  
       level_num := level_num + 1;  
       insert into level_tab values(child_tab_name, level_num);  
     end if;  
     <>  
     loop  
        fetch get_child_tab_name into child_tab_name;  /* other records */  
        exit  inner_loop when get_child_tab_name%notfound ;  
        insert into level_tab values(child_tab_name, level_num);  
     end loop inner_loop;  
     close get_child_tab_name;  
  end loop outer_loop;  
  commit;  
-- --------------------------------------------------------  
--  Keep only the highest level number row for a table name  
--  and delete rest of the duplicate rows from 'level_tab'.  
-- --------------------------------------------------------  
  <>  
  for loop_var in reverse 1..total_levels loop  
     open delete_duplicates(loop_var);  
     <>  
     loop  
        fetch delete_duplicates into tab_name;  
        exit  for_inner_loop when delete_duplicates%notfound ;  
        delete from level_tab  
         where level_number < loop_var and table_name = tab_name;  
     end loop for_inner_loop;  
     close delete_duplicates;  
  end loop for_loop;  
  commit;  
-- --------------------------------------------------  
--  update level numbers into parent_child_tab table  
--  by fetching the value from 'level_tab' table.  
-- --------------------------------------------------  
  update parent_child_tab  
     set p_level = (select level_number   
                      from level_tab  
        where table_name = parent_table_name );  
  commit;  
--  
  update parent_child_tab  
     set c_level = (select level_number   
                      from level_tab  
                     where table_name = child_table_name );  
  commit;  
end ;  
.  
/  
-- --------------------------------------------------------  
--  prepare spoolfile 'level_tree.lis' to capture the output  
--  generated by dbms.output utility package  
-- --------------------------------------------------------  
--  
set serveroutput on size 1000000  
spool level_tree.lis  
--  
-- ------------------------------  
--  Format and print the output  
-- ------------------------------  
declare  
   level_num             number(02);  
--  
   cursor get_parent_child_tab is  
     select distinct child_table_name, c_level, c_owner  
   from parent_child_tab  
      order by 2 desc, 1 ;               
--  
   cursor get_level_one_tab is  
     select distinct parent_table_name, p_owner from parent_child_tab  
       where p_level = 1  
      order by 1 ;               
--  
cursor print_tree(key1  varchar2) is  
     select lpad(' ',2*(level)) lpad_value,  
            parent_table_name t_name, p_owner, c_owner  
       from parent_child_tab  
       start with child_table_name = key1  
       connect by prior parent_table_name = child_table_name;  
--  
   cursor get_level_numbers(key2 varchar2) is  
     select level_number from level_tab  
       where table_name = key2;      
--  
begin  
   for xrec in get_parent_child_tab loop  
     dbms_output.put_line(  
        xrec.c_owner||'.'||xrec.child_table_name||'('||xrec.c_level||')');  
       for yrec in print_tree(xrec.child_table_name) loop  
         open get_level_numbers(yrec.t_name);  
         fetch get_level_numbers into level_num;  
         close get_level_numbers;  
         if level_num = 1 then  
           dbms_output.put_line(  
              '-'||yrec.lpad_value||yrec.p_owner||'.'  
              ||yrec.t_name||'('||level_num||')');  
         else  
           dbms_output.put_line(  
              '-'||yrec.lpad_value||yrec.c_owner||'.'  
               ||yrec.t_name||'('||level_num||')');  
         end if;  
       end loop;  
       dbms_output.put_line('-----------------------');  
   end loop;  
   for xrec in get_level_one_tab loop  
     dbms_output.put_line(  
          xrec.p_owner||'.'||xrec.parent_table_name||'(1)');  
   end loop;  
end ;  
.  
/  
-- -------------------------------------------------------------------  
spool off  
/  
drop table parent_child_tab  
/  
drop table parent_child_temp_tab  
/  
/* -------------------------------------------------------------------  
   'level_tab' table provides a useful list with a Sql statement:  
    SELECT * FROM LEVEL_TAB ORDER BY 2,1   
  
      Table name   Level number  
      -----------  ------------  
      table_five     1  
      table_four     1  
      table_one      2  
      table_two      3  
      table_three    4   
   -----------------------------------------------------------------  */  
drop table level_tab  
/ 
