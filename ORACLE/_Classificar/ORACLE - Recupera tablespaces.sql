begin
  set verify off;
  column value new_val blksize;
  select value from v$parameter where name = 'db_block_size';
  select a.file_id,
         a.file_name,
         ceil((nvl(hwm, 1) * &&blksize) / 1024) smallest,
         ceil(blocks * &&blksize / 1024) currsize,
         ceil(blocks * &&blksize / 1024) - ceil((nvl(hwm, 1) * &&blksize) / 1024) savings
    from dba_data_files a,
         (select file_id, max(block_id + blocks - 1) hwm
            from dba_extents
           where owner = 'FISC33'
           group by file_id) b
   where a.file_id = b.file_id;
end;

/*
SQL> 
SQL> set verify off;
SQL> column value new_val blksize;
SQL> select value from v$parameter where name = 'db_block_size';
 
VALUE
--------------------------------------------------------------------------------
32768
 
SQL> 
SQL> select a.file_id,
  2         a.file_name,
  3         ceil((nvl(hwm, 1) * &&blksize) / 1024) smallest,
  4         ceil(blocks * &&blksize / 1024) currsize,
  5         ceil(blocks * &&blksize / 1024) - ceil((nvl(hwm, 1) * &&blksize) / 1024) savings
  6    from dba_data_files a,
  7         (select file_id, max(block_id + blocks - 1) hwm
  8            from dba_extents
  9           where owner = 'FISC33'
 10           group by file_id) b
 11   where a.file_id = b.file_id;
 
 
   FILE_ID FILE_NAME                                                                          SMALLEST   CURRSIZE    SAVINGS
---------- -------------------------------------------------------------------------------- ---------- ---------- ----------
         6 /syn/rw01/data01/dad2_01.dbf                                                       37729472   41943040    4213568
         7 /syn/rw01/data01/dad3_01.dbf                                                       33202560   45088768   11886208
        12 /syn/rw01/data01/dad5_04.dbf                                                       36461376   52428800   15967424
        41 /syn/rw01/data01/ts_temp01.dbf                                                       875968    3145728    2269760
        17 /syn/rw01/idx01/idx4_01.dbf                                                        44016128   52428800    8412672
        25 /syn/rw01/data01/ts_ciap_dados01.dbf                                                 509824    1024000     514176
        39 /syn/rw01/data01/ts_syn_prcger_imp_01.dbf                                           4194496   38797312   34602816
         5 /syn/rw01/data01/dad1_01.dbf                                                       22847680   28311552    5463872
         8 /syn/rw01/data01/dad4_01.dbf                                                       23251328   26214400    2963072
        16 /syn/rw01/idx01/idx3_01.dbf                                                        17820352   31457280   13636928
        27 /syn/rw01/data01/ts_fis_arqmag_01.dbf                                               3584128    5120000    1535872
        29 /syn/rw01/idx01/ts_idx2_s5m_01.dbf                                                  8791168   15728640    6937472
        40 /syn/rw01/idx01/ts_syn_prcger_imp_01_idx.dbf                                       11305088   20971520    9666432
        18 /syn/rw01/idx01/idx4_02.dbf                                                        20622016   20971520     349504
        20 /syn/rw01/idx01/idx6_s5_01.dbf                                                     27545728   52428800   24883072
        32 /syn/rw01/data01/ts_in86_dados_carga_01.dbf                                          783488    3072000    2288512
        38 /syn/rw01/idx01/ts_syn_all_idx_01.dbf                                                 52288     204800     152512
        13 /syn/rw01/idx01/idx1_01.dbf                                                        10408576   13631488    3222912
        14 /syn/rw01/idx01/idx2_01.dbf                                                        18234752   52428800   34194048
        19 /syn/rw01/idx01/idx5_s160K_01.dbf                                                  13698528   28311552   14613024
 
   FILE_ID FILE_NAME                                                                          SMALLEST   CURRSIZE    SAVINGS
---------- -------------------------------------------------------------------------------- ---------- ---------- ----------
        26 /syn/rw01/idx01/ts_ciap_indices_01.dbf                                               189568    1024000     834432
        34 /syn/rw01/idx01/ts_in86_index_carga01.dbf                                           1039488    1536000     496512
         4 /syn/rw01/adm01/users01.dbf                                                             320      30720      30400
         9 /syn/rw01/data01/dad5_01.dbf                                                       40340224   52428800   12088576
        10 /syn/rw01/data01/dad5_02.dbf                                                       41835200   41943040     107840
        11 /syn/rw01/data01/dad5_03.dbf                                                       37381952   52428800   15046848
        15 /syn/rw01/idx01/idx2_02.dbf                                                        18587136   29360128   10772992
        21 /syn/rw01/idx01/idx6_s5_02.dbf                                                     30407808   30408704        896
        28 /syn/rw01/data01/ts_fis_arqmag_idx_01.dbf                                           3133248    4327424    1194176
        31 /syn/rw01/data01/ts_in86_dados_01.dbf                                                 30848    1024000     993152
        33 /syn/rw01/idx01/ts_in86_index.dbf                                                     15488     307200     291712
        37 /syn/rw01/data01/ts_syn_all_01.dbf                                                    96384     204800     108416
 
32 rows selected
*/
