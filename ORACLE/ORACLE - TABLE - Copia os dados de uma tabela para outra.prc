create or replace procedure copy_table(source in varchar2, target in varchar2, condition in varchar2 default null) is 
	-- Constantes
	crlf constant varchar2(2) default chr(13) || chr(10);   
  -- Tipo definido pelo desenvolvedor  
	type field is record
  (
    id        integer,
    name      varchar2(128),
    type      varchar2(64),
    length    integer,
    precision integer
  );
	type fields is table of field index by binary_integer;
	-- Variaveis do processo
	counter       integer default 1;
	cr_source     integer; 
	cr_target     integer; 
	fl_source     fields; 
	fl_target     fields; 
	ignore        integer;
	targetscript  varchar2(32767);
	sourcescript  varchar2(32767);
	-- Cria a lista de campos com base no meta data da tabela
	function create_field_list(tablename in varchar2) return fields as
    type rc_field is ref cursor;
		result   fields;
    cr_field rc_field;
		script   varchar2(32767);
		counter  integer default 1;
	begin
		-- Recupera o metadata da tabela
		script := 'select dtc.column_id      id,'         || crlf ||
							'       dtc.column_name    name,'       || crlf ||
							'	 		  dtc.data_type      type,'       || crlf ||
							'	 		  dtc.data_length    length,'     || crlf ||
							'	 		  dtc.data_precision precision'   || crlf ||
							'  from sys.dba_tab_columns dtc'        || crlf ||
							' where dtc.table_name = ' || tablename || crlf ||
							' order by dtc.column_id';
 		-- Carrega o vetor com a lista de campos
    open cr_field for script;
    loop
      fetch cr_field into
        result(counter).id,
				result(counter).name,
        result(counter).type,
        result(counter).length,
        result(counter).precision;
      exit when cr_field%notfound;
      counter := counter + 1;
    end loop;
		-- Retorna a lista de campos
		return result; 
	end;
	-- Verifica se os atributis dos campos das duas tabelas são iguais 
	function check_field_list(sourcelist in fields, targetlist in fields)return boolean as
		result  boolean default false;
		counter integer default 1;
	begin
		if sourcelist.count = targetlist.count then
			for counter in 1 .. sourcelist.count loop
				if (sourcelist(counter).id        = targetlist(counter).id)        and
					 (sourcelist(counter).name      = targetlist(counter).name)      and
					 (sourcelist(counter).type      = targetlist(counter).type)      and
					 (sourcelist(counter).length    = targetlist(counter).length)    and
					 (sourcelist(counter).precision = targetlist(counter).precision) then
					result := true;
				else
					return false;
					exit;
				end if;
			end loop;
		end if;
		return result;
	end;
	-- Carrega os valores da lista de origem para a lista de destino
	function load_field_list(sourcelist in fields, targetlist in out fields)return boolean as
		result  boolean default false;
		counter integer default 1;
	begin
		for counter in 1 .. sourcelist.count loop
			targetlist(counter).id        := sourcelist(counter).id;
			targetlist(counter).name      := sourcelist(counter).name;
			targetlist(counter).type      := sourcelist(counter).type;
			targetlist(counter).length    := sourcelist(counter).length;
			targetlist(counter).precision := sourcelist(counter).precision;
		end loop;
		return result;
	end;
	-- Cria um script com a instrução
	--     INSERT INTO <Tabela Destino> (<Lista de Campos Destino>)
	--     VALUES (<Lista de Parametros Origem>)
  function build_insert(sourcetable in varchar2, sourcelist in fields, targettable in varchar2, targetlist in fields) return varchar2 as
		result  varchar2(32767) default null;
		counter integer         default 1;
	begin
		result := 'insert into ' || targettable || crlf ||'('|| crlf;
		for counter in 1 .. targetlist.count loop
			if (counter <> 1) then
				result := result || ','|| crlf;
			end if;
			result := result || '' || targetlist(counter).name;
		end loop;
		result := result || crlf || ')' || crlf || 'values' || crlf || '(' || crlf;
		for counter in 1 .. sourcelist.count loop
			if (counter <> 1) then
				result := result || ',' || crlf;
			end if;
			if (sourcelist(counter).type = 'DATE') then
				result := result || 'to_date(:' || sourcelist(counter).name || ', ''dd/mm/yyyy'')';
			else
				result := result || ':' || sourcelist(counter).name;
			end if;
		end loop;
		result := result || crlf || ');';
		return result;
	end;
	-- Cria um script com a instrução
	--     INSERT INTO <Tabela Destino> (<Lista de Campos Destino>)
	--     SELECT <Lista de Campos Origem>
	--       FROM <Tabela Origem>
	--       WHERE <Condição Origem>
	function build_insertselect(sourcetable in varchar2, sourcelist in fields, targettable in varchar2, targetlist in fields, sourcecondition in varchar2 default null) return varchar2 as
		result  varchar2(32767) default null;
		counter integer         default 1;
	begin
		result := 'insert into ' || targettable || crlf ||'('|| crlf;
		for counter in 1 .. targetlist.count loop
			if (counter <> 1) then
				result := result || ','|| crlf;
			end if;
			result := result || '' || targetlist(counter).name;
		end loop;
		result := result || crlf || ')' || crlf || 'select' || crlf;
		for counter in 1 .. sourcelist.count loop
			if (counter <> 1) then
				result := result || ',' || crlf;
			end if;
			result := result || sourcelist(counter).name;
		end loop;
		result := result || crlf || 'from ' || sourcetable;
		if condition is null then
			result := result || ';';
		else	
			result := result || crlf || 'where ' || sourcecondition || ';';
		end if; 
	end;
	-- Cria um script com a instrução
	--     SELECT <Lista de Campos> FROM <Tabela> WHERE <Condição>
	function build_select(sourcetable in varchar2, sourcelist in fields, sourcecondition in varchar2 default null) return varchar2 as
		result  varchar2(32767) default null;
		counter integer         default 1;
	begin
		result := 'select' || crlf;
		for counter in 1 .. sourcelist.count loop
			if (counter <> 1) then
				result := result || ',' || crlf;
			end if;
			result := result || sourcelist(counter).name;
		end loop;
		result := result || crlf || 'from ' || sourcetable;
		if condition is null then
			result := result || ';';
		else	
			result := result || crlf || 'where ' || condition || ';';
		end if; 
		return result;
	end;

begin 
	-- Identifica as colunas das tabelas passadas e verifica se os campos de ambas são iguais
  fl_source := create_field_list(source);
  fl_target := create_field_list(target);
	if not (check_field_list(fl_source, fl_target)) then
		return;
	end if;
	-- Prepara o cursor com o select e configura as colunas na tabela source 
	sourcescript := build_select(source, fl_source, condition);
	cr_source := dbms_sql.open_cursor;
	dbms_sql.parse(cr_source, sourcescript, dbms_sql.native);
--------------------------------------------------------------------------------
--	for counter in 1 .. fl_source.count loop
--		case fl_source(counter).type
--			when 'VARCHAR2' then
--				dbms_sql.define_column(cr_source, fl_source(counter).id, fl_source(counter).name, fl_source(counter).length);
--		else
--				dbms_sql.define_column(cr_source, fl_source(counter).id, fl_source(counter).name);
--		end case;
--	end loop;
--------------------------------------------------------------------------------
	ignore := dbms_sql.execute(cr_source);
	-- Prepara o cursor com o insert na tabela target
	targetscript := build_insert(source, fl_source, target, fl_target);
	cr_target := dbms_sql.open_cursor;
	dbms_sql.parse(cr_target, targetscript, dbms_sql.native);
	-- Inicia o Fetch nas linhas da tabela source e inserindo na tabela target:
	loop
		if dbms_sql.fetch_rows(cr_source)>0 then 
			-- Obtem as colunas do registro recuperado:
--------------------------------------------------------------------------------
--			dbms_sql.column_value(cr_source, 1, id_var); 
--			dbms_sql.column_value(cr_source, 2, name_var); 
--			dbms_sql.column_value(cr_source, 3, birthdate_var); 
--			-- Vincular a linha no cursor que insere na tabela target:
--			dbms_sql.bind_variable(cr_target, ':id_bind', id_var); 
--			dbms_sql.bind_variable(cr_target, ':name_bind', name_var); 
--			dbms_sql.bind_variable(cr_target, ':birthdate_bind', birthdate_var);
--------------------------------------------------------------------------------
			ignore := dbms_sql.execute(cr_target); 
		else 
			-- Não existe mais registros a serem copiados:
			exit; 
		end if; 
	end loop; 
	-- Commit fecha os todos os cursores: 
	commit; 
	dbms_sql.close_cursor(cr_source); 
	dbms_sql.close_cursor(cr_target); 
exception 
	when others then 
		if dbms_sql.is_open(cr_source) then 
			dbms_sql.close_cursor(cr_source); 
		end if; 
		if dbms_sql.is_open(cr_target) then 
			dbms_sql.close_cursor(cr_target); 
		end if; 
		raise; 
end; 
/
