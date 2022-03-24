drop table lmm_compress
create table lmm_compress_tab
(
  fname varchar2(30),
  iblob blob
);




create or replace procedure lmm_compress(v_fname varchar2, vqual binary_integer) is
  src_file bfile;
  dst_file blob;
  lgh_file binary_integer;
  i        number;
begin
  src_file := bfilename('CTEMP', v_fname);
  i := dbms_utility.get_time;
  -- insert a NULL record to lock
  insert into lmm_compress_tab
    (fname, iblob)
  values
    ('Uncompressed', empty_blob())
  returning iblob into dst_file;
  -- lock record
  select iblob into dst_file from lmm_compress_tab where fname = 'Uncompressed' for update;
  -- open the file
  dbms_lob.fileopen(src_file, dbms_lob.file_readonly);
  -- determine length
  lgh_file := dbms_lob.getlength(src_file);
  -- read the file
  dbms_lob.loadfromfile(dst_file, src_file, lgh_file);
  -- update the blob field
  update lmm_compress_tab set iblob = dst_file where fname = 'Uncompressed';
  -- close file
  dbms_lob.fileclose(src_file);
  dbms_output.put_line(dbms_utility.get_time - i);
  --=====================================================
  i := dbms_utility.get_time;
  -- insert a NULL record to lock
  insert into lmm_compress_tab
    (fname, iblob)
  values
    ('Compressed', empty_blob())
  returning iblob into dst_file;
  -- lock record
  select iblob into dst_file from lmm_compress_tab where fname = 'Compressed' for update;
  -- open the file
  dbms_lob.fileopen(src_file, dbms_lob.file_readonly);
  -- determine length
  lgh_file := dbms_lob.getlength(src_file);
  -- read the file
  dbms_lob.loadfromfile(dst_file, src_file, lgh_file);
  -- update the blob field
  update lmm_compress_tab
     set iblob = utl_compress.lz_compress(dst_file, vqual)
   where fname = 'Compressed';
  commit;
  -- close file
  dbms_lob.fileclose(src_file);
  dbms_output.put_line(dbms_utility.get_time - i);
end lmm_compress;
/*
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
DECLARE
 i NUMBER;
 b BLOB;
BEGIN
  i := dbms_utility.get_time;

  SELECT iblob
  INTO b
  FROM test
  WHERE fname = 'Uncompressed';

  dbms_output.put_line('Uncompressed: ' ||
  TO_CHAR(dbms_utility.get_time - i));

  i := dbms_utility.get_time;

  SELECT utl_sys_compress.lz_uncompress(iblob)
  INTO b
  FROM test
  WHERE fname = 'Compressed';

  dbms_output.put_line('Uncompress: ' ||
  TO_CHAR(dbms_utility.get_time - i));
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
DECLARE
 bob    BLOB;
 rob    RAW(32767);
 handle BINARY_INTEGER;
 amount INTEGER := 32766/2;
 offset INTEGER := 1;
BEGIN
  SELECT iblob
  INTO bob
  FROM test
  WHERE fname = 'Compressed';

  SELECT utl_sys_compress.lz_uncompress_open(bob)
  INTO handle
  FROM dual;

  IF utl_sys_compress.isopen(handle) THEN
  dbms_output.put_line(handle);

  rob := dbms_lob.substr(bob, amount, offset);

  dbms_output.put_line('Unextracted: ' || length(rob));

  utl_sys_compress.lz_uncompress_extract(rob, handle);

  dbms_output.put_line('Extracted: ' || length(rob));

  utl_sys_compress.lz_uncompress_close(handle);
  END IF;
END;
*/


/*
CREATE OR REPLACE PROCEDURE compress_demo (v_fname VARCHAR2, vQual BINARY_INTEGER) IS
 src_file BFILE;
 dst_file BLOB;
 lgh_file BINARY_INTEGER;
 i NUMBER;
BEGIN
  src_file := bfilename('CTEMP', v_fname);

  i := dbms_utility.get_time;

  -- insert a NULL record to lock
  INSERT INTO test
  (fname, iblob)
  VALUES
  ('Uncompressed', EMPTY_BLOB())
  RETURNING iblob INTO dst_file;

  -- lock record
  SELECT iblob
  INTO dst_file
  FROM test
  WHERE fname = 'Uncompressed'
  FOR UPDATE;

  -- open the file
  dbms_lob.fileopen(src_file, dbms_lob.file_readonly);

  -- determine length
  lgh_file := dbms_lob.getlength(src_file);

  -- read the file
  dbms_lob.loadfromfile(dst_file, src_file, lgh_file);

  -- update the blob field
  UPDATE test
  SET iblob = dst_file
  WHERE fname = 'Uncompressed';

  -- close file
  dbms_lob.fileclose(src_file);

  dbms_output.put_line(dbms_utility.get_time - i);
  --=====================================================
  i := dbms_utility.get_time;

  -- insert a NULL record to lock
  INSERT INTO test
  (fname, iblob)
  VALUES
  ('Compressed', EMPTY_BLOB())
  RETURNING iblob INTO dst_file;

  -- lock record
  SELECT iblob
  INTO dst_file
  FROM test
  WHERE fname = 'Compressed'
  FOR UPDATE;

  -- open the file
  dbms_lob.fileopen(src_file, dbms_lob.file_readonly);

  -- determine length
  lgh_file := dbms_lob.getlength(src_file);

  -- read the file
  dbms_lob.loadfromfile(dst_file, src_file, lgh_file);

  -- update the blob field
  UPDATE test
  SET iblob = utl_compress.lz_compress(dst_file, vQual)
  WHERE fname = 'Compressed';

  COMMIT;

  -- close file
  dbms_lob.fileclose(src_file);

  dbms_output.put_line(dbms_utility.get_time - i);
END compress_demo;


DECLARE
 b      BLOB;
 r      RAW(32);
 handle BINARY_INTEGER;
BEGIN
  SELECT iblob
  INTO b
  FROM test
  WHERE fname = 'Uncompressed'
  FOR UPDATE;

  handle := utl_compress.lz_compress_open(b);

  IF NOT utl_compress.isopen(handle) THEN
    RAISE NO_DATA_FOUND;
  END IF;

  r := utl_raw.cast_to_raw('ABC');
  utl_compress.lz_compress_add(handle, b, r);
  utl_compress.lz_compress_close(handle, b);
END;





DECLARE
 i NUMBER;
 b BLOB;
BEGIN
  i := dbms_utility.get_time;

  SELECT iblob
  INTO b
  FROM test
  WHERE fname = 'Uncompressed';

  dbms_output.put_line('Uncompressed: ' ||
  TO_CHAR(dbms_utility.get_time - i));

  i := dbms_utility.get_time;

  SELECT utl_compress.lz_uncompress(iblob)
  INTO b
  FROM test
  WHERE fname = 'Compressed';

  dbms_output.put_line('Uncompress: ' ||
  TO_CHAR(dbms_utility.get_time - i));
END;



DECLARE
 ib       BLOB;
 ob       BLOB;
 dst_file BLOB;
 handle   BINARY_INTEGER;
BEGIN
  SELECT iblob
  INTO ib
  FROM test
  WHERE fname = 'Compressed';

  SELECT utl_compress.lz_uncompress_open(ib)
  INTO handle
  FROM dual;

  utl_compress.lz_uncompress_extract(handle, ob);

  INSERT INTO test
  (fname, iblob)
  VALUES
  ('Extracted', EMPTY_BLOB())
  RETURNING iblob INTO dst_file;

  -- lock record
  SELECT iblob
  INTO dst_file
  FROM test
  WHERE fname = 'Extracted'
  FOR UPDATE;

  UPDATE test
  SET iblob = ob
  WHERE fname = 'Extracted';
  COMMIT;

  utl_compress.lz_uncompress_close(handle);
  COMMIT;
END;

*/
