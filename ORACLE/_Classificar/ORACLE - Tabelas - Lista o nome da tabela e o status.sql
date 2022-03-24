declare
  type namelist is table of sys.all_tables.table_name%type;
  type sallist is table of sys.all_tables.status%type;
  cursor c1 is
    select t.table_name,
           t.status
      from sys.all_tables t
--     where salary > 10000
     order by t.table_name;
  names namelist;
  sals  sallist;
  type reclist is table of c1%rowtype;
  recs reclist;
  v_limit pls_integer := 10;
  procedure print_results is
  begin
    -- Check if collections are empty:
    if names is null or names.count = 0 then
      dbms_output.put_line('No results!');
    else
      dbms_output.put_line('Result: ');
      for i in names.first .. names.last loop
        dbms_output.put_line('  Employee ' || names(i) || ': $' || sals(i));
      end loop;
    end if;
  end;
begin
  dbms_output.put_line('--- Processing all results simultaneously ---');
  open c1;
  fetch c1 bulk collect
    into names,
         sals;
  close c1;
  print_results();
  dbms_output.put_line('--- Processing ' || v_limit || ' rows at a time ---');
  open c1;
  loop
    fetch c1 bulk collect
      into names,
           sals limit v_limit;
    exit when names.count = 0;
    print_results();
  end loop;
  close c1;
  dbms_output.put_line('--- Fetching records rather than columns ---');
  open c1;
  fetch c1 bulk collect
    into recs;
  for i in recs.first .. recs.last loop
    -- Now all columns from result set come from one record
    dbms_output.put_line('  Table ' || recs(i).table_name || ': $' || recs(i).status);
  end loop;
end;
