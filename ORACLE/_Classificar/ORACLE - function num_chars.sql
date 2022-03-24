drop function num_chars;

create function num_chars(instring varchar2, inpattern varchar2) return number is
  counter    number;
  next_index number;
  string     varchar2(2000);
  pattern    varchar2(2000);
begin
  counter    := 0;
  next_index := 1;
  string     := lower(instring);
  pattern    := lower(inpattern);
  for i in 1 .. length(string) loop
    if (length(pattern) <= length(string) - next_index + 1) and
       (substr(string, next_index, length(pattern)) = pattern) then
      counter := counter + 1;
    end if;
    next_index := next_index + 1;
  end loop;
  return counter;
end;
