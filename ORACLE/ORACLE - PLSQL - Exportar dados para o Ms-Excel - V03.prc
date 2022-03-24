create or replace procedure print_reports is
  cursor c_mgr is
    select t1.ename,
           t1.empno
      from emp t1
     where exists (select 'x'
                     from emp t2
                    where t1.empno = t2.mgr);
  cursor c_direct_reports(cv_mgr number) is
    select empno,
           ename,
           job,
           hiredate,
           sal
      from emp
     where mgr = cv_mgr;
  wfile_handle utl_file.file_type;
  v_wstring    varchar2(100);
  v_header     varchar2(100);
  v_file       varchar2(100);
  v_date       varchar2(20);
begin
  select to_char(sysdate, 'dd_mon_yyyy')
    into v_date
    from dual;
  v_header := 'empno'    || chr(9) ||
              'ename'    || chr(9) ||
              'job'      || chr(9) ||
              'hiredate' || chr(9) ||
              'sal';
  for r_mgr in c_mgr loop
    v_file := r_mgr.ename || '_direct_reports_' || v_date || '.xls';
    wfile_handle := utl_file.fopen('REPORTS', v_file, 'W');
    utl_file.put_line(wfile_handle, v_header);
    for r in c_direct_reports(r_mgr.empno) loop
      v_wstring := r.empno || chr(9) ||
                   r.ename || chr(9) ||
                   r.job   || chr(9) ||
                   to_char(r.hiredate, 'dd/mm/yyyy') || chr(9) ||
                   r.sal;
      utl_file.put_line(wfile_handle, v_wstring);
    end loop;
    utl_file.fclose(wfile_handle);
  end loop;
end print_reports;
/
