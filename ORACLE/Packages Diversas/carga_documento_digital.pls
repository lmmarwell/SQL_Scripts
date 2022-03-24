create or replace procedure carga_documento_digital as
    -- Variaveis para configuração do envio e retorno do XML
    xml_request   xmltype;
    xml_text      clob;
    --xml_text      varchar2(32676);
    http_request  utl_http.req;
    http_response utl_http.resp;
    txt_buffer    varchar2(1024);
    -- Variaveis com os dados do aquivo
    arquivo       sanfom.tmp_carga_documento.tx_base64%type;
    requesttoken  sanfom.tmp_carga_documento.cd_token_envio%type;
  begin
    -- Recupera o Documento Padrão carregado na tabe temporária
    select cd_token_envio,
           tx_base64
      into requesttoken,
           arquivo
      from sanfom.tmp_carga_documento;
    xml_request := xmltype('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:guar="http://www.ancine.gov.br/guardvol/">' || chr(13) || chr(10) ||
                              '<soapenv:Header/>'                                         || chr(13) || chr(10) ||
                              '<soapenv:Body>'                                            || chr(13) || chr(10) ||
                                 '<guar:guardarArquivoRequest>'                           || chr(13) || chr(10) ||
                                    '<arquivo>'      || arquivo      || '</arquivo>'      || chr(13) || chr(10) ||
                                    '<requestToken>' || requesttoken || '</requestToken>' || chr(13) || chr(10) ||
                                 '</guar:guardarArquivoRequest>'                          || chr(13) || chr(10) ||
                              '</soapenv:Body>'                                           || chr(13) || chr(10) ||
                           '</soapenv:Envelope>');
    dbms_output.put_line(xml_request.getclobval());
    dbms_output.put_line('------------------------------------------------------');
    xml_text := xml_request.getclobval();  
    dbms_output.put_line(xml_text);
    http_request := utl_http.begin_request(url => 'http://10.1.124.134/guardvol/GuardVol?wsdl', method => 'POST');
    utl_http.set_header(http_request, 'User-Agent', 'Mozilla/4.0');
    http_request.method := 'POST';
    utl_http.set_header (r => http_request, name => 'Content-Length', value => dbms_lob.getlength(xml_text));
    utl_http.write_text (r => http_request, data => xml_text);
    http_response := utl_http.get_response(http_request);
    loop
      utl_http.read_line(http_response, txt_buffer, true);  
      dbms_output.put_line(txt_buffer);
    end loop;
    utl_http.end_response(http_response);
  exception
    when utl_http.end_of_body then
      utl_http.end_response(http_response);
    when others then
      dbms_output.put_line('--------------------------------------------------------------------------------');
      dbms_output.put_line('ERRO : ' || sqlerrm                                                              );
      dbms_output.put_line('--------------------------------------------------------------------------------');
      dbms_output.put_line(xml_request.getclobval());
      dbms_output.put_line('--------------------------------------------------------------------------------');
      dbms_output.put_line(xml_text);
      dbms_output.put_line('--------------------------------------------------------------------------------');
  end carga_documento_digital;
