INSERT /*+ APPEND Parallel(A,6) */ into OWNER.TABELA A

select /*+ Parallel(B,6) */ * from OWNER.TABELA@migra2 B;

commit;