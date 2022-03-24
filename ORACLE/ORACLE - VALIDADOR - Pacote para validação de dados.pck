create or replace package validador is
  function cpf(Numero in varchar2) return boolean;
  function cnpj(Numero in varchar2) return boolean;
	function email(Email in varchar2) return boolean;
  function pispasep(Numero in varchar2) return boolean;
  function nit(Numero in varchar2) return boolean;
end validador;
/
create or replace package body validador is
  -- Validação de CPF
  function cpf(Numero in varchar2) return boolean as
    iTotal  pls_integer  default 0;
    iDigito pls_integer  default 0;
    sNumero varchar2(18) default replace(replace(Numero, '.', null), '-', null);
  begin
    for i in 1 .. 9 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (11 - i);
    end loop;
    iDigito := 11 - mod(iTotal, 11);
    if iDigito > 9 then
      iDigito := 0;
    end if;
    if iDigito != substr(sNumero, 10, 1) then
      return false;
    end if;
    iTotal := 0;
    for i in 1 .. 10 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (12 - i);
    end loop;
    iDigito := 11 - mod(iTotal, 11);
    if iDigito > 9 then
      iDigito := 0;
    end if;
    if iDigito != substr(sNumero, 11, 1) then
      return false;
		end if;
		return true;
  end;
  -- Validação de CNPJ
	function cnpj(Numero in varchar2) return boolean as
    iTotal  pls_integer  default 0;
    iDigito pls_integer  default 0;
    sNumero varchar2(18) default replace(replace(replace(Numero, '.', null), '-', null), '/', null);
  begin
    for i in 1 .. 4 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (6 - i);
    end loop;
    for i in 5 .. 12 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (14 - i);
    end loop;
    iDigito := 11 - mod(iTotal, 11);
    if iDigito > 9 then
      iDigito := 0;
    end if;
    if iDigito != substr(sNumero, 13, 1) then
      return false;
    end if;
    iTotal  := 0;
    for i in 1 .. 5 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (7 - i);
    end loop;
    for i in 6 .. 13 loop
      iTotal := iTotal + substr(sNumero, i, 1) * (15 - i);
    end loop;
    iDigito := 11 - mod(iTotal, 11);
    if iDigito > 9 then
      iDigito := 0;
    end if;
    if iDigito != substr(sNumero, 14, 1) then
      return false;
    end if;
    return true;
  end;
	-- Validação de e-mail
	function email(Email in varchar2) return boolean as
		sEmail  varchar2(1024);
		sPadrao varchar2(1024) default '^[a-z]+[\.\_\-[a-z0-9]+]*[a-z0-9]@[a-z0-9]+\-?[a-z0-9]{1,63}\.?[a-z0-9]{0,6}\.?[a-z0-9]{0,6}\.[a-z]{0,6}$';
	begin
		sEmail := lower(Email);
		if not owa_pattern.match (sEmail, sPadrao) then
			return (false);
		end if;
		if instr(Email,'..')  >  0  then
			return (false);
		end if;
		return (true);
	end;
  -- Validação do PIS/PASEP 
  function pispasep(Numero in varchar2) return boolean as
    fErro     varchar2(1)  default 'N';
    iTotal    pls_integer  default 0;
    iPosicao  pls_integer  default 1;
    iPeso     pls_integer  default 3;
    iAuxiliar pls_integer  default 0;
    iModulo   pls_integer  default 0;
    sNumero   varchar2(11) default trim (Numero);
  begin
    if nvl(length(sNumero), 0) <> 11 then
      return false;
    else
    while iPosicao < 3 loop
      iAuxiliar := to_number(substr(sNumero, iPosicao, 1)) * iPeso;
      iTotal    := iTotal + iAuxiliar;
      iPeso     := iPeso - 1;
      iPosicao  := iPosicao + 1;
    end loop;
    iPeso := 9;
    while iPosicao < 11 loop
      iAuxiliar := to_number(substr(sNumero, iPosicao, 1)) * iPeso;
      iTotal    := iTotal + iAuxiliar;
      iPeso     := iPeso - 1;
      iPosicao  := iPosicao + 1;
    end loop;
    iAuxiliar := mod(iTotal, 11);
    if iAuxiliar < 2 then
      iAuxiliar := 11;
    end if;
    iModulo := 11 - iAuxiliar;
    if iModulo <> to_number(substr(sNumero, 11, 1)) then
      fErro := 'S';
    else
      iPosicao := 1;
      while iPosicao < 11 loop
        iAuxiliar := iPosicao + 1;
        if substr(sNumero, iPosicao, 1) <> substr(sNumero, iAuxiliar, 1) then
          fErro    := 'N';
          iPosicao := 11;
        else
          iPosicao := iPosicao + 1;
        end if;
      end loop;
    end if;
    if fErro = 'N' then
      return true;
    else
      return false;
    end if;
  end if;
  end;
  -- Validação do NIT - Número de Identificação do Trabalhador
  function nit(Numero in varchar2) return boolean as
    iModulo      pls_integer default 2;
    iTotal       pls_integer default 0;
    iVerificador pls_integer default 0;
    iDigito      pls_integer default 0;
    iCont        pls_integer default 0;
    sNumero      varchar2(11) default trim (Numero);
  begin
    if length (sNumero) <> 11 then
      return false;
    end if;
    iVerificador := substr (sNumero, 11, 1);
    while iCont < 10 loop
      iCont := iCont + 1;
      iTotal := iTotal + (iModulo * substr (sNumero, 11 - iCont, 1));
      if iModulo < 9 then
        iModulo := iModulo + 1;
      else
        iModulo := 2;
      end if;
      iDigito := 11 - (iTotal mod 11);
      if iDigito > 9 then
        iDigito := 0;
      end if;
    end loop;
    if iVerificador = iDigito then
      return true;
    else
      return false;
    end if;
  end;
begin
  -- Initialization
  null;
end validador;
/
