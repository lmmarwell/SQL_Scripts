/*
--------------------------------------------------------------------------------
Script de Validação Básico do Modelo de Dados
 - Identifica as colunas/tabelas sem comentário
 - Indices criados fora do tablespace padrão
 - Foreign Key sem índice
 - Nome de coluna fora do padrão
--------------------------------------------------------------------------------
*/
declare 
  nCount          number;
  nCharComentario number;
  sOwner          varchar2(30);

begin
  nCount:=0;
  sOwner:= 'COAT';       --Nome do esquema a ser validado
  nCharComentario:= 10;  --Número mínimo de caracteres para um comentário
  --Evitar um erro do tipo ORA-20000: ORU-10027: Buffer Overflow, Limit of xxx bytes
  dbms_output.enable(100000); --Mais do que isso, tá muito ruim a qualidade do modelo ;-)
  --Identificando as TABELAS sem comentário (inclusive comentários com menos de 20 caracteres)
  for c in (select tc.table_name,
                   tc.comments
              from all_tab_comments tc
             where tc.owner   = sOwner
               and table_type = 'TABLE'
               and (tc.comments is null or length(tc.comments) < ncharcomentario)
             order by tc.table_name) loop
    if (nCount = 0) then 
      dbms_output.put_line ('### TABELAS SEM COMENTÁRIO ###');     
      dbms_output.put_line ('');     
      nCount:=1;
    end if;
    dbms_output.put_line (c.table_name || ' ' || c.comments);
  end loop;   
  if (nCount = 0) then 
    dbms_output.put_line ('### TODAS AS TABELAS POSSUEM COMENTÁRIO ###');
    dbms_output.put_line ('');     
  else
    dbms_output.put_line ('');     
  end if;
  --Identificando os CAMPOS sem comentário (inclusive comentários com menos de 20 caracteres)
  nCount:=0;
  for c1 in (select tc.table_name,
                    tc.column_name,
                    cc.comments
               from all_tab_columns tc
                    left join all_col_comments cc on (tc.column_name = cc.column_name and
                                                      tc.table_name  = cc.table_name)
              where tc.owner = sOwner
                and (cc.comments is null or length(cc.comments) < ncharcomentario)
              order by tc.table_name, tc.column_name) loop
    if (nCount = 0) then 
      dbms_output.put_line ('### COLUNAS SEM COMENTÁRIO ###');     
      dbms_output.put_line ('');     
      nCount:=1;
    end if;
    dbms_output.put_line (c1.table_name || '.' || c1.column_name || ' ' || c1.comments);
  end loop;   
  if (nCount = 0) then 
    dbms_output.put_line ('### TODAS AS COLUNAS POSSUEM COMENTÁRIO ###');
    dbms_output.put_line ('');     
  else
    dbms_output.put_line ('');     
  end if;
  --Identificando os CAMPOS sem comentário (inclusive comentários com menos de 20 caracteres)
  nCount:=0;
  for c1 in (select tc.table_name,
                    tc.column_name
               from all_tab_columns tc
              where tc.owner = sOwner
                and substr(tc.column_name, 1,2) not in ('CD','DE','DT','DH','ID','IN','NM','NR','OB','PC', 'QT', 'SG', 'VL')
              order by tc.table_name, tc.column_name) loop
    if (nCount = 0) then 
      dbms_output.put_line ('### NOME DE CAMPO FORA DO PADRÃO DA ANCINE ###');     
      dbms_output.put_line ('');     
      nCount:=1;
    end if;
      dbms_output.put_line (c1.table_name || '.' || c1.column_name );
  end loop;   
  if (nCount = 0) then 
    dbms_output.put_line ('### O NOME DE TODAS AS COLUNAS ESTÃO NO PADRÃO DA ANCINE ###');
    dbms_output.put_line ('');     
  else
    dbms_output.put_line ('');     
  end if;
  --identificando os ÍNDICES QUE NÃO FORAM CRIADOS NA TABLESPACE CORRETA
  nCount:=0;
  for c2 in (select table_name,
                    index_name,
                    tablespace_name
               from all_indexes
              where owner = sOwner
                and tablespace_name <> trim('TS_IND_' || sOwner)
              order by table_name) loop
    if (nCount = 0) then 
      dbms_output.put_line ('### ÍNDICES QUE NÃO FORAM CRIADOS NA TABLESPACE CORRETA (TS_IND_[OWNER]) ###');     
      dbms_output.put_line ('');     
      nCount:=1;
    end if;
    dbms_output.put_line (c2.table_name || '.' || c2.index_name || '( ATUAL: ' || c2.tablespace_name || ')');
  end loop;      
  if (nCount = 0) then 
    dbms_output.put_line ('### TODOS OS ÍNDICES FORAM CRIADOS NA TABLESPACE CORRETA ###');
    dbms_output.put_line ('');     
  else
    dbms_output.put_line ('');     
  end if;
  --ALTER INDEX <INDEX_NAME> REBUILD TABLESPACE <TABLESPACE_NAME>;
  --Identificando se TODOS as FOREIGN KEY possuem índice
  nCount:=0;
  --Seleciona TODAS as FK's
  for c3 in (select ac.table_name,
                    ac.constraint_name,
                    acc.column_name 
               from all_constraints ac
                    inner join all_cons_columns acc on (ac.constraint_name = acc.constraint_name) 
              where acc.owner       = sOwner
                and constraint_type = 'R'
                and not exists (select 1 
                                  from all_ind_columns i
                                 where i.table_name  = acc.table_name
                                   and i.column_name = acc.column_name)) loop
    if (nCount = 0) then 
      dbms_output.put_line ('### FOREIGN KEY SEM ÍNDICE ###');     
      dbms_output.put_line ('');     
      nCount:=1;
    end if;
      dbms_output.put_line (c3.table_name || '.' || c3.column_name);
  end loop;
  if (nCount = 0) then 
    dbms_output.put_line ('### TODOS AS FOREIGN KEY POSSUEM ÍNDICE ###');
    dbms_output.put_line ('');     
  else
    dbms_output.put_line ('');     
  end if;
end;

