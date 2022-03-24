procedure bulk_with_limit(dept_id_in in employees.department_id%type, limit_in in pls_integer default 100) is
  cursor employees_cur is
    select *
      from employees
     where department_id = dept_id_in;
  type employee_tt is table of employees_cur%rowtype index by pls_integer;
  l_employees employee_tt;
begin
  open employees_cur;
  loop
    fetch employees_cur bulk collect into l_employees limit limit_in;
    for indx in 1 .. l_employees.count loop
      process_each_employees(l_employees(indx));
    end loop;
    exit when employees_cur%notfound;
  end loop;
  close employees_cur;
end bulk_with_limit;
