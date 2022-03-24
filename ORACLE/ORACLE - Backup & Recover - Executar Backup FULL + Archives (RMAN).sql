RUN {
ALLOCATE CHANNEL ch00 TYPE DISK;
 sql 'alter system archive log current';
 BACKUP FILESPERSET 40 FORMAT 'bkp_database_%s_%p_%t' DATABASE;
 BACKUP FORMAT 'bkp_spfile_%s_%p_%t' SPFILE;
 BACKUP FILESPERSET 30 FORMAT 'bkp_archive_%s_%p_%t' ARCHIVELOG ALL;
 BACKUP FORMAT 'bkp_ctrl_%s_%p_%t' CURRENT CONTROLFILE;
RELEASE CHANNEL ch00;
}