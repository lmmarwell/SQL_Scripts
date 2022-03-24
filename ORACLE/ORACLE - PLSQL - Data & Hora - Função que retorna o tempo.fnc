CREATE OR REPLACE FUNCTION schema.retorna_tempo(P_DT_INICIAL IN DATE ,P_MASC IN VARCHAR2 := Null ,P_DT_FINAL IN DATE := Null) RETURN VARCHAR2 IS
Type Rec_Tempo Is Record(
   Qtd   Integer
  ,str Varchar2(10) );
vIndice    Integer := 0;
vMascara   Varchar2(60);
vData Date;
vRetorno   Varchar2(100);
vCaracter  Char(01);
vOculta     Boolean := False;  -->> False Oculsta, true exibe
vAno  Rec_Tempo; -->> Registro que irá armazenar o Ano
vMes  Rec_Tempo; -->> Registro que irá armazenar o Mes
vDia  Rec_Tempo; -->> Registro que irá armazenar o Dia
vHora  Rec_Tempo; -->> Registro que irá armazenar a Hora
vMin  Rec_Tempo; -->> Registro que irá armazenar o Minuto
BEGIN
  /*A função NVL é utilizada sempre que queremos que um determinado processo seja executado sem falhas, com isso
  quando encontra um parametro ou retorno da consulta com a possibilidade de ser nulo, utilizando a função para impedir
  que algum erro ocorra.*/
  vData := Nvl(P_DT_FINAL,Sysdate);
  vMascara       := Nvl( P_MASC, 'a' ); /*Estou deixando como mascará default, a de Ano*/
  vAno.Qtd := TO_CHAR(vData,'YYYY') - TO_CHAR(P_DT_INICIAL,'YYYY');
  IF vData - ADD_MONTHS( Trunc(P_DT_INICIAL), vAno.Qtd * 12 ) < 0 THEN
    vAno.Qtd := vAno.Qtd - 1;
  END IF;
  vMes.Qtd := Trunc(MONTHS_BETWEEN( vData, ADD_MONTHS( P_DT_INICIAL, vAno.Qtd * 12 ) ));
  vDia.Qtd := Trunc(vData - ADD_MONTHS( P_DT_INICIAL, (vAno.Qtd * 12) + vMes.Qtd ));
  vHora.Qtd := Trunc((vData - (ADD_MONTHS( P_DT_INICIAL, (vAno.Qtd * 12) + vMes.Qtd ) + vDia.Qtd))*24);
  vMin.Qtd := Trunc((vData - (ADD_MONTHS( P_DT_INICIAL, (vAno.Qtd * 12) + vMes.Qtd ) + vDia.Qtd))*24*60 - (vHora.Qtd*60));
  If vAno.Qtd > 1 Then
    vAno.str := 'Anos';
  Else
    vAno.str := 'Ano';
  End If;
  If vMes.Qtd > 1 Then
    vMes.str := 'Meses';
  Else
    vMes.str:= 'Mês';
  End If;
  If vDia.Qtd > 1 Then
    vDia.str:= 'Dias';
  Else
    vDia.str:= 'Dia';
  End If;
  If vHora.Qtd > 1 Then
    vHora.str:= 'Horas';
  Else
    vHora.str:= 'Hora';
  End If;
  If vMin.Qtd > 1 Then
    vMin.str:= 'Minutos';
  Else
    vMin.str:= 'Minuto';
  End If;
  vCaracter := Substr( vMascara, 1, 1 );  -->> Retorna o primeiro caracter da mascara
  If vCaracter = '#' Then  -->> O primeiro caracter sendo "#" indica que deverá inibir as informações zeradas
    vOculta := True;
    vIndice := 2;
    vCaracter := Substr( vMascara, 2, 1 );
    If vCaracter Is Null Then  -->> No caso da máscara ter apenas o caracter "#" então a função retornará Null
      Return Null;
    End If;
  Else
    vIndice := 1;
  End If;
  Loop
    If vCaracter = '"' Then
      Loop
        vIndice := vIndice + 1;
        vCaracter := Substr( vMascara, vIndice, 1 );
        Exit When vCaracter = '"' or vCaracter Is Null;
        vRetorno := vRetorno || vCaracter;
      End Loop;
    Else
      If vCaracter = 'a' Then  -->> Retorno da informação em forma numerica de Anos
        If vAno.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vAno.Qtd;
        End If;
      Elsif vCaracter = 'A' Then  -->> Retorno da informação em forma de texto de Anos
        If vAno.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vAno.Str;
        End If;
      Elsif vCaracter = 'm'       -->> Retorno da informação em forma numerica de Mês
        and Nvl(Substr(vMascara,vIndice+1,1),'.') <> 'i' Then   -->> Diferencia a mascara do mês e dos minutos
        If vMes.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vMes.Qtd;
        End If;
      Elsif vCaracter = 'M' -->> Retorno da informação em forma de texto do Mês
        and Nvl(Substr(vMascara,vIndice+1,1),'.') <> 'I' Then -->> Diferencia a mascara do mês e dos minutos
        If vMes.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vMes.Str;
        End If;
      Elsif vCaracter = 'd' Then  -->> Retorno da informação em forma numerica de Dias
        If vDia.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vDia.Qtd;
        End If;
      Elsif vCaracter = 'D' Then  --->> Retorno da informação em forma de texto de Dias
        If vDia.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vDia.Str;
        End If;
      Elsif vCaracter = 'h' Then  --->> Retorno da informação em forma numerica de Horas
        If vHora.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vHora.Qtd;
        End If;
      Elsif vCaracter = 'H' Then  -->> Retorno da informação em forma de texto de Horas
        If vHora.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vHora.Str;
        End If;
      Elsif vCaracter = 'm'       -->> Retorno da informação em forma numerica de Minutos
        and Nvl(Substr(vMascara,vIndice+1,1),'.') = 'i' Then   -->> Diferencia a mascara do mês e dos minutos
        If vMin.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vMin.Qtd;
        End If;
        vIndice := vIndice + 1;
      Elsif vCaracter = 'M'  -->> Retorno da informação em forma de texto de Minutos
        and Nvl(Substr(vMascara,vIndice+1,1),'.') = 'I' Then -->> Diferencia a mascara do mês e dos minutos
        If vMin.Qtd > 0 or Not vOculta Then
          vRetorno := vRetorno || vMin.Str;
        End If;
        vIndice := vIndice + 1;
      Elsif vCaracter = 'x' Then
        If vAno.Qtd >= 2 Then
          vRetorno := vRetorno || vAno.Qtd;
        Elsif vAno.Qtd = 1 or vMes.Qtd >= 2 Then
          vRetorno := vRetorno || ((vAno.Qtd*12)+vMes.Qtd);
        Elsif vMes.Qtd = 1 or vDia.Qtd >= 2 Then
          vRetorno := vRetorno || ( Trunc( vData ) - Trunc( P_DT_INICIAL ) );
        Elsif vOculta Then
          vRetorno := vRetorno;
        Elsif vDia.Qtd = 1 or vHora.Qtd >= 2 Then
          vRetorno := vRetorno || ( vDia.Qtd*24 + vHora.Qtd );
        Elsif vHora.Qtd = 1 and vMin.Qtd >= 2 Then
          vRetorno := vRetorno || ( vHora.Qtd*60 + vMin.Qtd );
        End If;
      Elsif vCaracter = 'X' Then
        If vAno.Qtd >= 2 Then
          vRetorno := vRetorno || vAno.Str;
        Elsif vAno.Qtd = 1 or vMes.Qtd >= 2 Then
          vRetorno := vRetorno || 'Meses';
        Elsif vMes.Qtd = 1 or vDia.Qtd >= 2 Then
          vRetorno := vRetorno || 'Dias';
        Elsif vOculta Then
          vRetorno := vRetorno;
        Elsif vDia.Qtd = 1 or vHora.Qtd >= 2 Then
          vRetorno := vRetorno || 'Horas';
        Elsif vHora.Qtd = 1 and vMin.Qtd >= 2 Then
          vRetorno := vRetorno || 'Minutos';
        End If;
      Else
        vRetorno := vRetorno || vCaracter;
      End If;
    End If;
    vIndice := vIndice + 1;
    vCaracter := Substr( vMascara, vIndice, 1 );
    Exit When vCaracter Is Null;
  End Loop;
  Return vRetorno;
END retorna_tempo;
/
