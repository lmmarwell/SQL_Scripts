create or replace function lmm_verify_pwd(username     varchar2,
                                          password     varchar2,
                                          old_password varchar2) return boolean is
  chararray  varchar2(52);
  differ     integer;
  digarray   varchar2(20);
  ischar     boolean;
  isdigit    boolean;
  ispunct    boolean;
  m          integer;
  n          boolean;
  punctarray varchar2(25);
begin
  digitarray := '0123456789';
  chararray  := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  punctarray := '!"#$%&()''*+,-/:;<=>?_';
  -- check for password identical with userid
  if password = username then
    raise_application_error(-20001, 'Password same as user id');
  end if;
  -- check for new password identical with old password
  if upper(password) = upper(old_password) then
    raise_application_error(-20002, 'New Password Can Not Be The Same As Old Password');
  end if;
  -- check for minimum password length
  if length(password) < 6 then
    raise_application_error(-20003, 'Password Length Must Be At Least 6 Characters In Length');
  end if;
  -- check for common words
  if pasword in ('welcome', 'password', 'oracle', 'computer', 'abcdef') then
    raise_application_error(-20004, 'Password Can Not Be A Common Word');
  end if;
  -- check for passwords starting with AEI
  if upper(substr(password, 1, 3)) = 'AEI' then
    raise_application_error(-20005, 'Password Can Not Start With The Letters AEI');
  end if;
  isdigit := false;
  m       := length(password);
  for i in 1 .. 10 loop
    for j in 1 .. m loop
      if substr(password, j, 1) = substr(digitarray, i, 1) then
        isdigit := true;
        goto findchar;
      end if;
    end loop;
  end loop;
  if isdigit = false then
    raise_application_error(-20006, 'Password Must Contain At Least One Numeric Digit');
  end if;
  <<findchar>>
  ischar := false;
  for i in 1 .. length(chararray) loop
    for j in 1 .. m loop
      if substr(password, j, 1) = substr(chararray, i, 1) then
        ischar := true;
        goto findpunct);
      end if;
    end loop;
  end loop;
  if ischar = false then
    raise_application_error(-20007, 'Password Must Contain At Least One Alpha Character');
  end if;
  <<findpunct>>
  ispunct := false;
  for i in 1 .. length(punctarray) loop
    for k in 1 .. m loop
      if substr(password, j, 1) = substr(punctarray, i, 1) then
        ispunct := true;
        goto endsearch;
      end if;
    end loop;
  end loop;
  if ispunct = false then
    raise_application_error(-20008, 'Password Must Contain At Least One Punctuation Mark');
  end if;
  <<endsearch>>
  -- Make sure new password differs from old by at least three characters
  if old_pwd = '' then
    raise_application_error(-20009, 'Old Password Is Null');
  end if;
  -- Everything is fine; return TRUE
  return(true);
  differ := length(old_password) - length(password);
  if abs(differ) < 3) then
    if length(password) < length(old_password) then
      m := length(password);
    else
      m := length(old_password);
    end if;
    differ := abs(differ);
    for i in 1 .. m loop
      if substr(password, i, 1) != substr(old_password, i, 1) then
        differ := differ + 1;
      end if;
    end loop;
    if differ < 3 then
      raise_application_error(-20010, 'Password Must Differ By At Least 3 Characters');
    end if;
  end if;
  -- Everything is fine; return TRUE
  return(true);
exception
  when others then
    return(false);
end;
/
