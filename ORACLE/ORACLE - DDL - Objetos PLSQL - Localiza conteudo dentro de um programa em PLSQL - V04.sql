select a.*
  from sys.all_source a
 where upper(a.text) like '%NICHO%'
--   and a.owner = 'S5B'
 order by a.owner, a.name, a.line;


emi.controle_integracao
