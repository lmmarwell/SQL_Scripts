create or replace package data_file_manager is
---------------------------------------------------------------------------------------------------
-- Pacote que permite exportar informações e dados de uma tabela para arquivo DBF padrão DBsae III 
-- Criado por Luciano Merighetti Marwell  - lmmarwell@oi.com.br - MWL Sitemas LTDA                
---------------------------------------------------------------------------------------------------
-- Declaração publica de funções
  function first_row(p_primeira_linha in boolean) return varchar2;
  function split(p_list in varchar2, p_del in varchar2 default ',') return split_table pipelined;
  function ntrim(p_texto in varchar2) return varchar2;
  function dec2hex(p_numero in number) return varchar2;
  function hex2dec(p_numero in varchar2) return number;
  function to_dec(p_numero in varchar2) return number;
  function build_insert(p_tabela in varchar2, p_flds in field_descriptor_array) return varchar2;
  function get_row (p_bfile in bfile, p_bfile_offset in out number, p_hdr in dbf_header, p_flds in field_descriptor_array) return rowarray;
-- Declaração publica de procedimentos
  procedure put_row(p_tabela in varchar2, p_where in varchar2 default '1 = 1', p_row in out rowarray, p_flds in field_descriptor_array);
  procedure get_header(p_bfile in bfile, p_bfile_offset in out number, p_hdr in out dbf_header, p_flds in out field_descriptor_array);
  procedure put_header(p_tabela in varchar2, p_campos in varchar2 default null, p_hdr in out dbf_header, p_flds in out field_descriptor_array);
  procedure show(p_hdr in dbf_header, p_flds in field_descriptor_array, p_tabela in varchar2, p_bfile in bfile);
  function dump(p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_campo in varchar2 default null, p_no_records number default 0, p_close in boolean default false, p_flds in out field_descriptor_array) return utl_file.file_type;
  procedure dump_table (p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_campo in varchar2 default null, p_where in varchar2 default '1 = 1');
  procedure dump_share(p_dir in varchar2, p_file in varchar2, p_limit in number, p_tabela in varchar2, p_campo in varchar2 default null, p_where in varchar2 default '1 = 1');
  procedure load_table(p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_show in boolean default false);
  procedure open_table(p_dir in varchar2, p_file in varchar2);
end data_file_manager;
/
create or replace package body data_file_manager is
---------------------------------------------------------------------------------------------------
-- Pacote que permite exportar informações e dados de uma tabela para arquivo DBF padrão DBsae III 
-- Criado por Luciano Merighetti Marwell  - lmmarwell@oi.com.br - MWL Sitemas LTDA                
---------------------------------------------------------------------------------------------------
	-- Declaração publica de constantes
  big_endian constant boolean default true;
  crlf constant varchar2(2) default chr(13) || chr(10);    
	
	-- Declaração publica de variaveis
  g_cursor binary_integer default dbms_sql.open_cursor;

	-- Declaração publica de tipo
  type dbf_header is record
  (
    version    varchar2(25),
    date       char(6),
    year       int,
    month      int,
    day        int,
    no_records string(8),      
    hdr_len    string(4),
    rec_len    string(4),
    no_fields  string(4)
  );
  type field_descriptor is record
  (
    name     varchar2(11),
    type     char(1),
    length   int,
    decimals int,
    fname    varchar2(30)
  );
  type field_descriptor_array is table of field_descriptor index by binary_integer;
  type rowarray is table of varchar2(4000) index by binary_integer;
  type split_table is table of varchar2(32767); 
	
  -- Insere simblo de concatenação apos a primeira coluna
  function first_row(p_primeira_linha in boolean) return varchar2 as
  begin
    if p_primeira_linha then
      return '||';
    else
      return null;
    end if;
  end;
  -- Função que cria uma tabela simulando a função split do VB
  function split(p_list in varchar2, p_del in varchar2 default ',') return split_table pipelined as
    l_idx  pls_integer;
    l_list varchar2(32767) := trim(p_list);
  begin
    loop
      l_idx := instr(l_list, p_del);
      if l_idx > 0 then
        pipe row(substr(l_list, 1, l_idx - 1));
        l_list := substr(l_list, l_idx + length(p_del));
      else
        pipe row(l_list);
        exit;
      end if;
    end loop;
    return;
  end;
  -- Função que simula o TRIM limitando o tamanho do nome do campo em 11 caracteres
  function ntrim(p_texto in varchar2) return varchar2 as
    l_icont number;
    l_jcont number;
  begin
    for l_icont in 1 .. 11 loop
      if ascii(substr(p_texto, l_icont, 1)) = 0 then
        l_jcont := l_icont;
        exit;
      end if;
    end loop;
    return substr(p_texto, 1, l_jcont - 1);
  end;
  -- Converte de Decimal para Hexadecimal
  function dec2hex(p_numero in number) return varchar2 is
    type t_data is record (valor number(10));
    type t_matrix is table of t_data index by binary_integer;
    l_aux    t_matrix;
    l_cont   number(10);
    l_rest   number(10)  default 0;
    l_numero number(10)  default p_numero;
    result   varchar2(8) default null;
  begin
    while(p_numero >= 16) loop
      l_rest := mod(l_numero, 16);
      l_aux(l_cont).valor := l_rest;
      l_numero := ((l_numero - l_rest) / 16);
      l_cont := l_cont + 1;
    end loop;
    l_aux(l_cont).valor := l_numero;
    while(l_cont >= 0) loop
      case l_aux(l_cont).valor
        when 10 then result := result || 'A';
        when 11 then result := result || 'B';
        when 12 then result := result || 'C';
        when 13 then result := result || 'D';
        when 14 then result := result || 'E';
        when 15 then result := result || 'F';
      else
        result := result || l_aux(l_cont).valor;
      end case;
      l_cont := l_cont - 1;
    end loop;
    return result;
  end;
  -- Converte de Hexadecimal para Decimal
  function hex2dec(p_numero in varchar2) return number as
    l_cont        number(10);
    l_byte        number(10)  default length(p_numero);
    l_byte_string varchar2(1);
    l_byte_number number(10);
    result        number(10);
  begin
    if(l_byte > 0) then
      for l_cont in 1 .. l_byte loop
        l_byte_string := substr(p_numero, l_byte - l_cont + 1, 1);
        case l_byte_string
          when 'A' then l_byte_number := 10;
          when 'B' then l_byte_number := 11;
          when 'C' then l_byte_number := 12;
          when 'D' then l_byte_number := 13;
          when 'E' then l_byte_number := 14;
          when 'F' then l_byte_number := 15;
        else
          l_byte_number := to_number(l_byte_string);
        end case;
        result := result + l_byte_number * power(16, (l_cont - 1));
      end loop;
    end if;
    return result;
  end;
  -- Função para converter um hexadecimal em unsigned integer
  function to_dec(p_numero in varchar2) return number as
    l_cont number(10);
    l_byte number default length(p_numero);
    result number default 0;
  begin
    if (big_endian) then
      for l_cont in 1 .. l_byte loop
        result := result + ascii(substr(p_numero, l_cont, 1)) * power(2, 8 * (l_cont - 1));
      end loop;
    else
      for l_cont in 1 .. l_byte loop
        result := result + ascii(substr(p_numero, l_byte - l_cont + 1, 1)) * power(2, 8 * (l_cont - 1));
      end loop;
    end if;
    return result;
  end;
  -- Gera o script de insert na tabela
  function build_insert(p_tabela in varchar2, p_flds in field_descriptor_array) return varchar2 as
    l_cont number(10);
    result long;
  begin
    result := 'insert into ' || p_tabela  ||'(';
    for l_cont in 1 .. p_flds.count loop
      if (l_cont <> 1) then
        result := result || ',';
      end if;
      result := result || '' || p_flds(l_cont).name;
    end loop;
    result := result || ') ' || 'values' || '(';
    for l_cont in 1 .. p_flds.count loop
      if (l_cont <> 1) then
        result := result || ',';
      end if;
      if (p_flds(l_cont).type = 'D') then
        result := result || 'to_date(:' || p_flds(l_cont).name || l_cont || ', ''yyyymmdd'' )';
      else
        result := result || ':' || p_flds(l_cont).name;
      end if;
    end loop;
    result := result || ');';
    return result;
  end;
  -- Recupera a linha e envia para uma matriz dividindo a string
  function get_row(p_bfile in bfile, p_bfile_offset in out number, p_hdr in dbf_header, p_flds in field_descriptor_array) return rowarray as
    l_cont   number(10);
    l_dados  varchar2(4000);
    l_numero number default 2;
    l_linha  rowarray;
  begin
    l_dados := utl_raw.cast_to_varchar2(dbms_lob.substr(p_bfile, p_hdr.rec_len, p_bfile_offset));
    p_bfile_offset := p_bfile_offset + p_hdr.rec_len;
    l_linha(0) := substr(l_dados, 1, 1);
    for l_cont in 1 .. p_hdr.no_fields loop
      l_linha(l_cont) := rtrim(ltrim(substr(l_dados, l_numero, p_flds(l_cont).length)));
      if (p_flds(l_cont).type = 'F') and (l_linha(l_cont) = '.') then
        l_linha(l_cont) := null;
      end if;
      l_numero := l_numero + p_flds(l_cont).length;
    end loop;
    return l_linha;
  end;
  -- Escreve a linha no buffer
  procedure put_row(p_tabela in varchar2, p_where in varchar2 default '1 = 1', p_row in out rowarray, p_flds in field_descriptor_array) as
    type rc_script is ref cursor;
    cr_script rc_script;
    l_cont    number(10);
    l_campo   varchar2(32767);
    l_script  varchar2(32767);
  begin
    for l_cont in 1..p_flds.count loop
      l_campo := l_campo || first_row(l_cont != 1) ||
                 case p_flds(l_cont).type
                   when 'N' then 'lpad(nvl(to_char('
                   else 'rpad(nvl('
                 end ||
                 p_flds(l_cont).fname ||
                 case p_flds(l_cont).type
                   when 'N' then
                     case p_flds(l_cont).decimals
                       when 0 then', ' || chr(39) || rpad(9, p_flds(l_cont).length, 9) || chr(39) || ')'
                       else ', ' || chr(39) || rpad(9, (p_flds(l_cont).length - p_flds(l_cont).decimals - 1), 9) || '.' || rpad(9, p_flds(l_cont).decimals, 9) || chr(39) || ')'
                     end
                 end ||
                 ', ' || chr(39) || chr(32) || chr(39) || '), ' || p_flds(l_cont).length || ', ' || chr(39) || chr(32) || chr(39) || ')';
    end loop;
    l_cont := 0;
    l_script := 'select '            || crlf ||
                l_campo              || crlf ||
                'from '  || p_tabela || crlf ||
                'where ' || p_where;
    open cr_script for l_script;
    loop
      l_cont := l_cont + 1;
      fetch cr_script into p_row(l_cont);
      exit when cr_script%notfound;
    end loop;
    close cr_script;
  end;
  -- Rotina para analisar o cabeçalho dBase registro, recupera todos os detalhes do
  -- conteúdo de um arquivo do dBase a partir deste cabeçalho
  procedure get_header(p_bfile in bfile, p_bfile_offset in out number, p_hdr in out dbf_header, p_flds in out field_descriptor_array) as
    l_cont     number(10);
    l_dados    varchar2(100);
    l_hdr_size number default 32;
    l_fld_size number default 32;
    l_flds     field_descriptor_array;
  begin
    p_flds := l_flds;
    l_dados := utl_raw.cast_to_varchar2(dbms_lob.substr(p_bfile, l_hdr_size, p_bfile_offset));
    p_bfile_offset   := p_bfile_offset + l_hdr_size;
    p_hdr.version    := ascii(substr(l_dados, 1, 1));
    p_hdr.date       := lpad(ascii(substr(l_dados, 2, 1)), 2, 0) ||
                        lpad(ascii(substr(l_dados, 3, 1)), 2, 0) ||
                        lpad(ascii(substr(l_dados, 4, 1)), 2, 0);
    p_hdr.no_records := to_dec(substr(l_dados, 5, 4));
    p_hdr.hdr_len    := to_dec(substr(l_dados, 9, 2));
    p_hdr.rec_len    := to_dec(substr(l_dados, 11, 2));
    p_hdr.no_fields  := trunc((p_hdr.hdr_len - l_hdr_size) / l_fld_size);
    for l_cont in 1 .. p_hdr.no_fields loop
      l_dados := utl_raw.cast_to_varchar2(dbms_lob.substr(p_bfile, l_fld_size, p_bfile_offset));
      p_bfile_offset := p_bfile_offset + l_fld_size;
      p_flds(l_cont).name     := ntrim(substr(l_dados, 1, 11));
      p_flds(l_cont).type     := substr(l_dados, 12, 1);
      p_flds(l_cont).length   := ascii(substr(l_dados, 17, 1));
      p_flds(l_cont).decimals := ascii(substr(l_dados, 18, 1));
    end loop;
    p_bfile_offset := p_bfile_offset + mod( p_hdr.hdr_len - l_hdr_size, l_fld_size );
  end;
  -- Recupera o cabeçalho do arquivo dbf aberto
  procedure put_header(p_tabela in varchar2, p_campos in varchar2 default null, p_hdr in out dbf_header, p_flds in out field_descriptor_array) as
    type rc_coluna is ref cursor;
    cr_coluna rc_coluna;
    l_cont    number(10);
    l_script  varchar2(4000);
  begin
    l_script := '  select substr(column_name, 1, 10) name,' || crlf ||
                '         case data_type' || crlf ||
                '           when ''DATE''   then ''D''' || crlf ||
                '           when ''NUMBER'' then ''N''' || crlf ||
                '           else ''C''' || crlf ||
                '         end type,' || crlf ||
                '         case data_type' || crlf ||
                '           when ''DATE''   then 8' || crlf ||
                '           when ''NUMBER'' then nvl(data_precision, 22)' || crlf ||
                '           else data_length' || crlf ||
                '         end length,' || crlf ||
                '         case data_type' || crlf ||
                '           when ''NUMBER'' then data_scale' || crlf ||
                '           else 0' || crlf ||
                '         end decimals,' || crlf ||
                '         column_name fname' || crlf ||
                '    from all_tab_cols' || crlf ||
                '   where table_name = trim(upper(' || chr(39) || p_tabela || chr(39) || '))' || crlf;
    if p_campos is not null then
      l_script := l_script || '     and column_name in(select trim(upper(column_value)) from table(aderente.data_file_manager.split(' || chr(39) || p_campos || chr(39) || ')))' || crlf;
    end if;
    l_script := l_script || 'order by column_id';
    l_cont := 0;
    open cr_coluna for l_script;
    loop
      l_cont := l_cont + 1;
      fetch cr_coluna into
        p_flds(l_cont).name,
        p_flds(l_cont).type,
        p_flds(l_cont).length,
        p_flds(l_cont).decimals,
        p_flds(l_cont).fname;
      exit when cr_coluna%notfound;
    end loop;
    close cr_coluna;
    p_hdr.version   := '03';
    p_hdr.year      := to_number(to_char(sysdate, 'yyyy')) - 2000;
    p_hdr.month     := to_number(to_char(sysdate, 'mm'));
    p_hdr.day       := to_number(to_char(sysdate, 'dd'));
    p_hdr.rec_len   := 1;
    p_hdr.no_fields := p_flds.count;
    p_hdr.hdr_len   := ((p_hdr.no_fields * 32) + 33);
  end;
  -- Exibe informações do arquivo dbf aberto
  procedure show(p_hdr in dbf_header, p_flds in field_descriptor_array, p_tabela in varchar2, p_bfile in bfile) as
    l_cont      number(10);
    l_separador varchar2(2) default ', ';
    l_estrutura varchar2(4000);
    procedure imprime_linha(p_texto in varchar2) is
      l_texto long default p_texto;
    begin
      dbms_output.put_line(l_texto);
    end;
  begin
    imprime_linha('Tamanho do arquivo dBase: ' || dbms_lob.getlength(p_bfile));
    imprime_linha('DBASE Informações do cabeçalho: ');
    imprime_linha(chr(9)  || 'Versão...............: ' || p_hdr.version);
    imprime_linha(chr(9)  || 'Ultima alteração.....: ' || p_hdr.date);
    imprime_linha(chr(9)  || 'Numero de Registros..: ' || p_hdr.no_records);
    imprime_linha(chr(9)  || 'Tamanho do Cabeçalho.: ' || p_hdr.hdr_len);
    imprime_linha(chr(9)  || 'Tamanho do Registro..: ' || p_hdr.rec_len);
    imprime_linha(chr(9)  || 'Numero de Campos.....: ' || p_hdr.no_fields);
    imprime_linha(chr(10) || 'Informação dos Campos: ');
    for l_cont in 1 .. p_hdr.no_fields loop
      l_estrutura := 'Campo(' || l_cont || ') => '  ||
                     'Nome....: ' || p_flds(l_cont).name   || l_separador ||
                     'Tipo....: ' || p_flds(l_cont).Type   || l_separador ||
                     'Tamanho.: ' || p_flds(l_cont).length || l_separador ||
                     'Decimal.: ' || p_flds(l_cont).decimals;
      imprime_linha(l_estrutura);
    end loop;
    imprime_linha(chr(10) || 'Insert.:' );
    imprime_linha(build_insert(p_tabela, p_flds));
    imprime_linha( chr(10) || 'Script para criação da tabela:');
    imprime_linha( 'create table ' || p_tabela );
    imprime_linha( '(' );
    for l_cont in 1 .. p_hdr.no_fields loop
      if l_cont = p_hdr.no_fields then
        l_separador := null;
      end if;
      dbms_output.put(chr(9) || p_flds(l_cont).name || ' ');
      case p_flds(l_cont).type
        when 'D' then imprime_linha('date' || l_separador);
        when 'F' then imprime_linha('float' || l_separador);
        when 'N' then
          case p_flds(l_cont).decimals
            when 0 then imprime_linha('number(' || p_flds(l_cont).length || ')' || l_separador);
            else imprime_linha('number(' || p_flds(l_cont).length || ', ' || p_flds(l_cont).decimals || ')' || l_separador);
          end case;
        else imprime_linha('varchar2(' || p_flds(l_cont).length || ')' || l_separador);
      end case;
    end loop;
    imprime_linha(')');
  end;
  -- Cria um arquivo com a estrutura informada
  function dump(p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_campo in varchar2 default null, p_no_records number default 0, p_close in boolean default false, p_flds in out field_descriptor_array) return utl_file.file_type as
    l_cont  number(10);
    l_file  utl_file.file_type;
    l_hdr   dbf_header;
    l_linha rowarray;
  begin
    -- Recupera os dados para o cabeçalho
    put_header(p_tabela, p_campo, l_hdr, p_flds);
    -- Cria o arquivo vazio
    l_file := utl_file.fopen(p_dir, p_file, 'w', 32767);
    -- Calcula o tamanho da linha com os campos
    for l_cont in 1..p_flds.count loop
      l_hdr.rec_len := l_hdr.rec_len + p_flds(l_cont).length;
    end loop;
    -- Total de registros
    if p_no_records = 0 then
      l_hdr.no_records := to_char(l_linha.count, 'FM0000000x');
    else
      l_hdr.no_records := to_char(p_no_records, 'FM0000000x');
    end if;
    l_hdr.no_records := substr(l_hdr.no_records, -2) || substr(l_hdr.no_records, 5, 2) || substr(l_hdr.no_records, 3, 2) || substr(l_hdr.no_records, 1, 2);
    -- Tamanho da linha de cabeçalho
    l_hdr.hdr_len := to_char(to_number(l_hdr.hdr_len), 'FM000x');
    l_hdr.hdr_len := substr(l_hdr.hdr_len, -2) || substr(l_hdr.hdr_len, 1, 2);
    -- Tamanho máxino da linha de registro
    l_hdr.rec_len := to_char(to_number(l_hdr.rec_len), 'FM000x');
    l_hdr.rec_len := substr(l_hdr.rec_len, -2) || substr(l_hdr.rec_len, 1, 2);
    -- Monta alinha de cabeçalho
    utl_file.put_raw(l_file,
                     rpad(l_hdr.version ||
                          to_char(l_hdr.year,'FM0x')  ||
                          to_char(l_hdr.month,'FM0x') ||
                          to_char(l_hdr.day,'FM0x')   ||
                          l_hdr.no_records            ||
                          l_hdr.hdr_len               ||
                          l_hdr.rec_len,
                          64,
                          '0'
                         )
                    );
    -- Adiciona ao cabeçalho a linha de com os dados dos campos
    for l_cont in 1..p_flds.count loop
      utl_file.put_raw(l_file,
                       utl_raw.cast_to_raw(p_flds(l_cont).name) ||
                       replace(rpad('00', 12 - length(p_flds(l_cont).name), '#'), '#', '00') ||
                       utl_raw.cast_to_raw(p_flds(l_cont).type) ||
                       '00000000' ||
                       to_char(p_flds(l_cont).length,'FM0x') ||
                       case
                         when trim(p_flds(l_cont).decimals) is null then '000000000000000000000000000000'
                         else to_char(p_flds(l_cont).decimals,'FM0x') || '0000000000000000000000000000'
                       end
                      );
    end loop;
    -- Verifica se é para fechar o arquivo
    if p_close then
      -- Fecha o arquivo
      if utl_file.is_open(l_file) then
        utl_file.fclose(l_file);
      end if;
      return null;
    else
      -- Retorna o arquivo aberto
      return l_file;
    end if;
  end;
  -- Cria um arquivo com a estrutura informada e alimenta com as informações da tabela
  procedure dump_table(p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_campo in varchar2 default null, p_where in varchar2 default '1 = 1') as
    l_cont  number(10);
    l_file  utl_file.file_type;
    l_flds  field_descriptor_array;
    l_linha rowarray;
    l_where varchar2(4000);
  begin
    l_where := p_where;
    if trim(l_where) is null then
      l_where := '1 = 1';
    end if;
    l_file := dump(p_dir, p_file, p_tabela, p_campo, 0, false, l_flds);
    put_row(p_tabela, l_where, l_linha, l_flds);
    for l_cont in 1..l_linha.count loop
      if l_cont = 1 then
        utl_file.put_line(l_file, chr(0) || chr(26) || replace(l_linha(l_cont), ',', '.'), true);
      elsif l_cont = l_linha.count then
        utl_file.put_line(l_file, replace(l_linha(l_cont), ',', '.') || chr(26), true);
      else
        utl_file.put_line(l_file, replace(l_linha(l_cont), ',', '.'), true);
      end if;
    end loop;
    if utl_file.is_open(l_file) then
      utl_file.fclose(l_file);
    end if;
  end;
  -- Cria um arquivo com a estrutura informada e alimenta com as informações da tabela partindo no limite informado
  procedure dump_share(p_dir in varchar2, p_file in varchar2, p_limit in number, p_tabela in varchar2, p_campo in varchar2 default null, p_where in varchar2 default '1 = 1') as
    type rc_script is ref cursor;
    cr_script    rc_script;
    l_file       utl_file.file_type;
    l_flds       field_descriptor_array;
    l_where      varchar2(4000);
    l_file_name  varchar2(128);
    l_script     varchar2(32767);
    l_campo      varchar2(32767);
    l_registro   number(10);
    l_share_cont number(10) default 1;
    l_share_file number(10) default 1;
    l_cont       number(10) default 0;
  begin
    -- Verifica se existe condição v´lida para a clausula WHERE
    l_where := p_where;
    if trim(l_where) is null then
      l_where := '1 = 1';
    end if;
    -- Monta o nome para o primeiro arquivo
    l_file_name := upper(p_file) || '_' || trim(to_char(l_share_file, '099999'));
--    l_file_name := left(upper(p_file), len(p_file) - 4) ||
--                   '_' ||
--                   trim(to_char(l_share_file, '099999'))
--                   || substr(upper(p_file), len(upper(p_file)) - 3, 4);
    -- Recupera o total de registro da tabela
    l_script := 'select count(1) from ' || p_tabela || ' where '  || l_where;
    open cr_script for l_script;
    fetch cr_script into l_registro;
    close cr_script;
    -- Cria o primeiro arquivo. Verifica se o total de registros é menor que o limite
    if l_registro >= p_limit then
      l_file := dump(p_dir, l_file_name, p_tabela, p_campo, p_limit, false, l_flds);
    else
      l_file := dump(p_dir, l_file_name, p_tabela, p_campo, l_registro, false, l_flds);
    end if;
    -- Inicia o processo de escrita do arquivo dividido
    for l_cont in 1..l_flds.count loop
      -- Monta a lista de campos que será usada para cria a linha de dados
      l_campo := l_campo || first_row(l_cont != 1) ||
                 case l_flds(l_cont).type
                   when 'N' then 'lpad(nvl(trim(to_char('
                   when 'D' then 'lpad(nvl(to_char('
                   else 'rpad(nvl('
                 end ||
                 l_flds(l_cont).fname ||
                 case l_flds(l_cont).type
                   when 'N' then
                     case l_flds(l_cont).decimals
                       when 0 then', ' || chr(39) || rpad(9, l_flds(l_cont).length, 9) || chr(39) || '))'
                       else ', ' || chr(39) || rpad(9, (l_flds(l_cont).length - l_flds(l_cont).decimals - 1), 9) || '.' || rpad(9, l_flds(l_cont).decimals, 9) || chr(39) || '))'
                     end
                   when 'D' then
                      ', ' || chr(39) || 'YYYYMMDD' || chr(39) || ')'
                 end ||
                 ', ' || chr(39) || chr(32) || chr(39) || '), ' || l_flds(l_cont).length || ', ' || chr(39) || chr(32) || chr(39) || ')';
    end loop;
    -- Cria um cursor por referencia para receber os dados para montar as linhas
    l_script := 'select '  || crlf ||
                l_campo    || crlf ||
                '  from '  || p_tabela || crlf ||
                ' where '  || l_where;
    -- Abre o cursor
    open cr_script for l_script;
    -- Varre o cursor
    loop
      -- Contra a variavel l_cmapo, atribuindo os dados
      l_cont := l_cont + 1;
      fetch cr_script into l_campo;
      exit when cr_script%notfound;
      -- Verifica se é a primeira linha a ser gravada no arquivo
      -- para efetuar o tratamento adeguado                     
      if l_cont = 1 then
        utl_file.put_line(l_file, chr(0) || chr(26) || replace(l_campo, ',', '.'), true);
      elsif l_cont = p_limit then
        utl_file.put_line(l_file, replace(l_campo, ',', '.') || chr(26), true);
      else
        utl_file.put_line(l_file, replace(l_campo, ',', '.'), true);
      end if;
      -- Verifica se ultrpassou o limite para o arquivo
      if l_share_cont = p_limit then
        l_share_cont := 1;
        l_cont := 0;
        utl_file.fclose(l_file);
        l_share_file := l_share_file + 1;
        l_file_name := upper(p_file) || '_' || trim(to_char(l_share_file, '099999'));
--      l_file_name := left(upper(p_file), len(p_file) - 4) ||
--                     '_' ||
--                     trim(to_char(l_share_file, '099999'))
--                     || substr(upper(p_file), len(upper(p_file)) - 3, 4);

        l_registro := l_registro - p_limit;
        if l_registro >= p_limit then
          l_file := dump(p_dir, l_file_name, p_tabela, p_campo, p_limit, false, l_flds);
        else
          l_file := dump(p_dir, l_file_name, p_tabela, p_campo, l_registro, false, l_flds);
        end if;
      else
        l_share_cont := l_share_cont + 1;
      end if;
    end loop;
    -- Fechar o crusor
    close cr_script;
    -- Fecha o ultimo arquivo escrito
    if utl_file.is_open(l_file) then
      utl_file.fclose(l_file);
    end if;
  end;
  -- Recupera as informações sovre o arquivo dbf indicado
  procedure load_table(p_dir in varchar2, p_file in varchar2, p_tabela in varchar2, p_show in boolean default false) as
    l_bfile  bfile;
    l_offset number default 1;
    l_hdr    dbf_header;
    l_flds   field_descriptor_array;
    l_row    rowArray;
  begin
    l_bfile := bfilename(p_dir, p_file);
    dbms_lob.fileopen(l_bfile);
    get_header(l_bfile, l_offset, l_hdr, l_flds);
    if p_show then
      show(l_hdr, l_flds, p_tabela, l_bfile);
    else
      dbms_sql.parse(g_cursor, build_insert(p_tabela, l_flds), dbms_sql.native);
      for i in 1 .. l_hdr.no_records loop
        l_row := get_row(l_bfile, l_offset, l_hdr, l_flds);
        if l_row(0) <> '*' then
          for i in 1..l_hdr.no_fields loop
            dbms_sql.bind_variable( g_cursor, ':bv' || i, l_row(i), 4000);
          end loop;
          if dbms_sql.execute(g_cursor) <> 1 then
            dbms_output.put_line( '-20001' || 'Erro ao tentar abrir o arquivo. ERRO ORACLE: ' || sqlerrm );
          end if;
        end if;
      end loop;
    end if;
    dbms_lob.fileclose(l_bfile);
  exception
    when others then
      if (dbms_lob.isopen(l_bfile) >0 ) then
        dbms_lob.fileclose( l_bfile );
      end if;
      dbms_output.put_line( '-20001' || 'Erro ao tentar abrir o arquivo. ERRO ORACLE: ' || sqlerrm );
  end;
  -- Abre o arquivo dbf em modo de leitura e escrita
  procedure open_table(p_dir in varchar2, p_file in varchar2) as
    file_name bfile;
  begin
    file_name:=bfilename(p_dir, p_file);
    dbms_lob.open(file_name);
  end;
begin
  dbms_output.put_line('inicia as variaveis globais do pacote');
  dbms_output.put_line(sysdate);
end data_file_manager;
/
