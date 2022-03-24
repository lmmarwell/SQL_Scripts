begin
  dbms_session.set_nls ('NLS_DATE_FORMAT','''dd/mm/yyyy''');
  dbms_session.set_nls ('NLS_TIME_FORMAT','''hh24:mi:ss''');
  dbms_session.set_nls ('NLS_TIMESTAMP_FORMAT','''dd/mm/yyyy hh24:mi:ss''');
end;

select *
  from nls_session_parameters
-- where parameter = 'NLS_DATE_FORMAT'
