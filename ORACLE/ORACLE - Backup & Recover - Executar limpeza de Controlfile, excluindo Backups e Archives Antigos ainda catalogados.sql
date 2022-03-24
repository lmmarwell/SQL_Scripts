run {
 sql 'alter system checkpoint';
 delete noprompt archivelog all completed before 'sysdate-1';
 crosscheck backup of database;
 crosscheck copy;
 crosscheck backupset;
 crosscheck archivelog all;
 delete noprompt expired backup;
}