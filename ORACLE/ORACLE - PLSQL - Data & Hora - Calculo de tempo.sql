select lpad(trunc(&valor/60/60), 2, '0')  || ':' ||
       lpad(trunc(&valor/60), 2, '0')  || ':' ||
       lpad(round(((&valor / 60)- trunc(&valor / 60)) * 60), 2, '0') tempo_execucao
  from dual
