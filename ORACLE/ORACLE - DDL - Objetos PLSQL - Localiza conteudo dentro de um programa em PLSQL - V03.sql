select a.*
  from sys.all_source a
 where upper(a.text) like '%''08''%'
   and a.name = 'FC_RESTRICAO_SERASA'
 order by a.owner, a.name, a.line;
