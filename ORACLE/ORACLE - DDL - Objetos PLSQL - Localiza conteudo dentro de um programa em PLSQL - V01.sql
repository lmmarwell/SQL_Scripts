--------------------------------------------------------------
select distinct
       a.owner || '.' || a.name objeto
  from all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%')
   and a.owner = user
 order by a.owner || '.' || a.name
--------------------------------------------------------------
select distinct
       a.owner || '.' || a.name objeto
  from all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%')
   and a.owner = user
 order by a.owner || '.' || a.name
--------------------------------------------------------------
select distinct
       a.owner || '.' || a.name objeto,
       a.line linha,
       a.text texto
  from all_source a
 where upper(a.text) like '%TELEF%'
   and (upper(a.text) like '%VARCHAR2(8)%' or
        upper(a.text) like '%NUMBER(8)%')
   and a.owner = user
 order by a.owner || '.' || a.name,
       a.line
--------------------------------------------------------------
select distinct
       a.owner || '.' || a.name objeto,
       a.line linha,
       a.text texto
  from all_source a
 where upper(a.text) like '%PR_VER_HIST_INFOMARKETING%'
 order by a.owner || '.' || a.name,
       a.line
