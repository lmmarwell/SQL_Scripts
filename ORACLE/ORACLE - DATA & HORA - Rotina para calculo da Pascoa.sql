--------------------------------------------------------------------------------
/*
O cálculo da data da Páscoa, também conhecido como Computus em latim, é fundamental
no calendário cristão desde os primórdios da cristandade, tornando-se definido na
Idade Média.

A Páscoa é celebrada no primeiro domingo após a primeira lua cheia que ocorre
depois do equinócio da Primavera (no hemisfério norte, outono no hemisfério sul),
ou seja, é equivalente à antiga regra de que seria o primeiro Domingo após o
14º dia do mês lunar de Nissan. Poderá assim ocorrer entre 22 de Março e 25 de Abril.
Os dias extremos deste intervalo correspondem muito raramente a dias de Páscoa.
A última vez que ocorreu a 22 de Março foi em 1818 e a próxima será em 2285. Menos
raras são as Páscoas a 23 de Março (anos 1913, 2008 e 2160) e 25 de Abril
(anos 1943, 2038 e 2190).

Outradas datas calculadas com base do dia da Pascoa:
  Dia do Carnaval: basta subtrair 47 dias da data da Páscoa.
  Corpus Christi: pode ser obtido somando-se 60 dias à data da Páscoa.

Fonte: https://pt.wikipedia.org/wiki/Cálculo_da_Páscoa
*/
--------------------------------------------------------------------------------
declare
  ano number(10) default &nu_ano;
  a   number(10) default 0;
  b   number(10) default 0;
  c   number(10) default 0;
  d   number(10) default 0;
  e   number(10) default 0;
  f   number(10) default 0;
  g   number(10) default 0;
  h   number(10) default 0;
  I   number(10) default 0;
  j   number(10) default 0;
  K   number(10) default 0;
  l   number(10) default 0;
  m   number(10) default 0;
  mes number(10) default 0;
  dia number(10) default 0;
begin
  a   := mod(ano, 19);
  b   := trunc(ano / 100);
  c   := mod(ano, 100);
  d   := trunc(b / 4);
  e   := mod(b, 4);
  f   := trunc((b + 8) / 25);
  g   := trunc((b - f + 1) / 3);
  h   := mod((19 * a + b - d - g + 15), 30);
  i   := trunc(c / 4);
  k   := mod(c, 4);
  l   := mod((32 + 2 * e + 2 * i - h - k), 7);
  m   := trunc((a + 11 * h + 22 * l) / 451);
  mes := trunc((h + l - 7 * m + 114) / 31);
  dia := (mod((h + l - 7 * m + 114), 31) + 1);
  --------------------------
  dbms_output.put_line(ano);
  dbms_output.put_line(a);
  dbms_output.put_line(b);
  dbms_output.put_line(c);
  dbms_output.put_line(d);
  dbms_output.put_line(e);
  dbms_output.put_line(f);
  dbms_output.put_line(g);
  dbms_output.put_line(h);
  dbms_output.put_line(i);
  dbms_output.put_line(k);
  dbms_output.put_line(l);
  dbms_output.put_line(m);
  dbms_output.put_line(mes);
  dbms_output.put_line(dia);
  dbms_output.put_line('Domingo de Páscoa do ano ' || ano || ' caiu em ' || lpad(dia, 2, '0') || '/' || lpad(mes, 2, '0'));
  --------------------------
end;