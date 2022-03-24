-----------------------------------------------------------------------
-- Retorna lista de campos e as tabelas
select sc.Name as "Nome do Campo",
       so.Name as "Nome da Tabela"
from syscolumns sc
     inner join sysobjects so on sc.id = so.id
where upper(so.Name) like '%CAPT%'
order by 1, 2;
-----------------------------------------------------------------------
-- Retorna lista de campos 
select tabelas.name       tabela,
       colunas.colid      colid,
       colunas.name       coluna,
       tipos.name         tipo,
       colunas.length     tamanho,
       colunas.isnullable eh_nulo
  from sysobjects tabelas,
       syscolumns colunas,
       systypes   tipos
 where tabelas.id = colunas.id
   and upper(colunas.name) like '%DTCAPT%'
   and colunas.usertype = tipos.usertype
order by 1, 2;
-----------------------------------------------------------------------
-- Retorna os campos de uma tabela
select tabelas.name       tabela,
       colunas.colid      colid,
       colunas.name       coluna,
       tipos.name         tipo,
       colunas.length     tamanho,
       colunas.isnullable eh_nulo
  from sysobjects tabelas,
       syscolumns colunas,
       systypes   tipos
 where tabelas.id = colunas.id
   and colunas.usertype = tipos.usertype
   and upper(tabelas.name) = 'PROJETOS'
   and tipos.name = 'datetime'
order by 2;