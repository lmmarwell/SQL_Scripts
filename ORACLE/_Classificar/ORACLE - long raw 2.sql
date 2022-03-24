CREATE OR REPLACE FUNCTION trans_demo(pin IN VARCHAR2)
RETURN VARCHAR2 IS
 r_in  long RAW(2000);
 r_out long RAW(2000);
 r_ul  long RAW(64);
 r_lu  long RAW(64);
BEGIN
  r_in := utl_raw.cast_to_raw(pin);
  r_ul := utl_raw.cast_to_raw('ABCDEFabcdef');
  r_lu := utl_raw.cast_to_raw('abcdefABCDEF');

  r_out := utl_raw.translate(r_in , r_ul, r_lu);

  return(utl_raw.cast_to_varchar2(r_out));
END trans_demo;
/

SELECT trans_demo('FaDe') FROM dual;
SELECT trans_demo('FAde') FROM dual;

select trans_demo(doc) from t1;
