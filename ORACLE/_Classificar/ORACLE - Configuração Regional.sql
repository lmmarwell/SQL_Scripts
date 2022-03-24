declare
	cursor nlsparamscursor is
		select * from nls_session_parameters;
begin
	select nvl(lengthb(chr(65536)), nvl(lengthb(chr(256)), 1))
		into :charlength
		from dual;
	for nlsrecord in nlsparamscursor loop
		if nlsrecord.parameter = 'NLS_DATE_LANGUAGE' then
			:nlsdatelanguage := nlsrecord.value;
		elsif nlsrecord.parameter = 'NLS_DATE_FORMAT' then
			:nlsdateformat := nlsrecord.value;
		elsif nlsrecord.parameter = 'NLS_NUMERIC_CHARACTERS' then
			:nlsnumericcharacters := nlsrecord.value;
		elsif nlsrecord.parameter = 'NLS_TIMESTAMP_FORMAT' then
			:nlstimestampformat := nlsrecord.value;
		elsif nlsrecord.parameter = 'NLS_TIMESTAMP_TZ_FORMAT' then
			:nlstimestamptzformat := nlsrecord.value;
		end if;
	end loop;
end;