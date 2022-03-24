--------------------------------------------------------------------------------  
-- INSERT INTO <Tabela Destino> (<Lista de Campos Destino>)
-- VALUES (<Lista de Parametros Origem>)
--------------------------------------------------------------------------------
declare
	crlf constant varchar2(2)     default chr(13) || chr(10);
	result        varchar2(32767) default null;
	counter       int             default 1;
begin
	result := 'insert into ' || 'targettable' || crlf ||'('|| crlf;
	for counter in 1 .. 10 loop
		if (counter <> 1) then
			result := result || ','|| crlf;
		end if;
		result := result || '' || 'targetlist(' || counter || ').name';
	end loop;
	result := result || crlf || ')' || crlf || 'values' || crlf || '(' || crlf;
	for counter in 1 .. 10 loop
		if (counter <> 1) then
			result := result || ',' || crlf;
		end if;
--		if (sourcelist(counter).type = 'DATE') then
		if (counter = 9) then
			result := result || 'to_date(:' || 'sourcelist(' || counter || ').name' || ', ''dd/mm/yyyy'')';
		else
			result := result || ':' || 'sourcelist(' || counter || ').name';
		end if;
	end loop;
	result := result || crlf || ');';
--	return result;
	dbms_output.put_line(result);		
end;
--------------------------------------------------------------------------------  
-- INSERT INTO <Tabela Destino> (<Lista de Campos Destino>)
-- SELECT <Lista de Campos Origem>
--   FROM <Tabela Origem>
--  WHERE <Condição Origem>
--------------------------------------------------------------------------------
declare
	crlf constant varchar2(2)     default chr(13) || chr(10);
	result        varchar2(32767) default null;
	counter       int             default 1;
	condition     varchar2(32767) default 'sourcelist(' || counter || ').name = targetlist(' || counter || ').name';
begin
	result := 'insert into ' || 'targettable' || crlf ||'('|| crlf;
	for counter in 1 .. 10 loop
		if (counter <> 1) then
			result := result || ','|| crlf;
		end if;
		result := result || '' || 'targetlist(' || counter || ').name';
	end loop;
	result := result || crlf || ')' || crlf || 'select' || crlf;
	for counter in 1 .. 10 loop
		if (counter <> 1) then
			result := result || ',' || crlf;
		end if;
		result := result || 'sourcelist(' || counter || ').name';
	end loop;
	result := result || crlf || 'from sourcetable';
	if condition is null then
		result := result || ';';
	else	
		result := result || crlf || 'where ' || condition || ';';
	end if; 
--	return result;
	dbms_output.put_line(result);		
end;
--------------------------------------------------------------------------------  
-- SELECT <Lista de Campos Origem>
--   FROM <Tabela Origem>
--  WHERE <Condição Origem>
--------------------------------------------------------------------------------
declare
	crlf constant varchar2(2)     default chr(13) || chr(10);
	result        varchar2(32767) default null;
	counter       int             default 1;
	condition     varchar2(32767) default 'sourcelist(' || counter || ').name = targetlist(' || counter || ').name';
begin
	result := 'select' || crlf;
	for counter in 1 .. 10 loop
		if (counter <> 1) then
			result := result || ',' || crlf;
		end if;
		result := result || 'sourcelist(' || counter || ').name';
	end loop;
	result := result || crlf || 'from sourcetable';
	if condition is null then
		result := result || ';';
	else	
		result := result || crlf || 'where ' || condition || ';';
	end if; 
--	return result;
	dbms_output.put_line(result);		
end;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
select dtc.column_id      id,
       dtc.column_name    name,
			 dtc.data_type      type,
			 dtc.data_length    length,
			 dtc.data_precision precision
  from sys.dba_tab_columns dtc
 where dtc.table_name = 'SYN_PRC_GERADO'
 order by dtc.column_id
--------------------------------------------------------------------------------
select p.owner,
       p.name,
       t.num_rows,
       ltrim(t.cache) ch,
       decode(t.buffer_pool, 'KEEP', 'Y', 'DEFAULT', 'N') K,
       s.blocks blocks,
       sum(a.executions) nbr_FTS,
       p.options,
       p.operation
  from dba_tables t,
       dba_segments s,
       v$sqlarea a,
       (select distinct address, object_owner owner, object_name name, options, operation
          from v$sql_plan
--         where options = 'FULL'
--           and operation = 'TABLE ACCESS'
       ) p
 where a.address = p.address
   and t.owner = s.owner
   and t.table_name = s.segment_name
   and t.table_name = p.name
   and t.owner = p.owner
--   and t.owner not in ('SYS', 'SYSTEM')
   and t.owner in ('FISC33')
 group by p.owner,
          p.name,
          t.num_rows,
          t.cache,
          t.buffer_pool,
          s.blocks,
          p.options,
          p.operation
--having sum(a.executions) > 9
 order by sum(a.executions) desc;
--------------------------------------------------------------------------------
select * from table(lmm_simulador.split('1;2;3;4;5;6;7;8;9', ';'))
--------------------------------------------------------------------------------
select distinct
       dtc.data_type
  from sys.dba_tab_columns dtc
  order by dtc.data_type
	
/*
procedure define_column(c in integer, position in integer, column in number);
procedure define_column(c in integer, position in integer, column in varchar2 character set any_cs, column_size in integer);
procedure define_column(c in integer, position in integer, column in date);
procedure define_column(c in integer, position in integer, column in blob);
procedure define_column(c in integer, position in integer, column in clob character set any_cs);
procedure define_column(c in integer, position in integer, column in bfile);
procedure define_column(c in integer, position in integer, column in urowid);
procedure define_column(c in integer, position in integer, column in time_unconstrained);
procedure define_column(c in integer, position in integer, column in timestamp_unconstrained);
procedure define_column(c in integer, position in integer, column in TIME_TZ_UNCONSTRAINED);
procedure define_column(c in integer, position in integer, column in TIMESTAMP_TZ_UNCONSTRAINED);
procedure define_column(c in integer, position in integer, column in TIMESTAMP_LTZ_UNCONSTRAINED);
procedure define_column(c in integer, position in integer, column in YMINTERVAL_UNCONSTRAINED);
procedure define_column(c in integer, position in integer, column in DSINTERVAL_UNCONSTRAINED);
procedure define_column(c in integer, position in integer, column in binary_float);
procedure define_column(c in integer, position in integer, column in binary_double);
*/
