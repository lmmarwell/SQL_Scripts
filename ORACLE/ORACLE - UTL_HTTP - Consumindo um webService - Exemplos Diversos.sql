declare
  req   utl_http.req;
  resp  utl_http.resp;
  value varchar2(1024);
begin
  req := utl_http.begin_request('http://www-hr.corp.my-company.com');
  utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');  
  resp := utl_http.get_response(req);  
  loop
    utl_http.read_line(resp, value, true);
    dbms_output.put_line(value);
  end loop;
  utl_http.end_response(resp);  
exception
  when utl_http.end_of_body then
  utl_http.end_response(resp);
end;



declare
  -- String that holds the HTTP request string
  soap_request       varchar2(32767);
  -- PL/SQL record to represent an HTTP request, as returned from the call to begin_request
  http_req           utl_http.req;
  -- PL/SQL record to represent the output of get_response 
  http_resp          utl_http.resp;
  -- HTTP version that can be used in begin_request: 1.0 or 1.1
  t_http_version     varchar2(10) default 'HTTP/1.1';
  t_content_type     varchar2(50) default 'text/xml; charset=utf-8';
  --  URL of the HTTP request, set after begin_request.
  t_url              varchar2(100) default 'wsf.cdyne.com/WeatherWS/Weather.asmx';
  -- Variables to handle the web service response
  x_clob             clob;
  l_buffer           varchar2(32767); 
  -- US city ZIP for which the weather data has to be fetched via web service
  l_zip              varchar2(10) default '10007'; 
begin
  dbms_output.put_line('ZIP: ' || l_zip );
  -- Build the HTTP soap request
  soap_request := '<?xml version="1.0" encoding="utf-8"?>' ||
                  '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' ||
                  'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' ||
                  '  <soap:Body>' ||
                  '    <GetCityWeatherByZIP xmlns="http://ws.cdyne.com/WeatherWS/">' ||
                  '      <ZIP>' || l_zip || '</ZIP>' ||
                  '    </GetCityWeatherByZIP>' ||
                  '  </soap:Body>' ||
                  '</soap:Envelope>';  

  -- Begin a new HTTP request: establish the network connection to the target web server or proxy server and send the HTTP request line.
  http_req := utl_http.begin_request(t_url, 'POST', t_http_version);
  -- Set HTTP request header attributes. The request header is sent to the web server as soon as it is set.
  utl_http.set_header(http_req, 'Content-Type', t_content_type);
  utl_http.set_header(http_req, 'Content-Length', length(soap_request));
  utl_http.set_header(http_req, 'SOAPAction', '"http://ws.cdyne.com/WeatherWS/GetCityWeatherByZIP"');
  -- Write soap request text data in the HTTP request
  utl_http.write_text(http_req, soap_request);
  -- GET_RESPONSE: output of record type utl_http.resp. http_resp contains a 3-digit status_code, areason_phrase and HTTP version.
  http_resp := utl_http.get_response(http_req);
  -- Build a CLOB variable to hold web service response
  dbms_lob.createtemporary(x_clob, FALSE );
  dbms_lob.open( x_clob, dbms_lob.lob_readwrite );
  begin
    loop
      -- Copy the web service response body in a buffer string variable l_buffer
      utl_http.read_text(http_resp, l_buffer);
      -- Append data from l_buffer to CLOB variable
      dbms_lob.writeappend(x_clob, length(l_buffer), l_buffer);
    end loop;
  exception
      when others then
        --  Exit loop without exception when end-of-body is reached
        if sqlcode <> -29266 then
          raise;
        end if;
  end;
  -- Verify the response status and text
  dbms_output.put_line('Response Status: '  ||http_resp.status_code ||' ' || http_resp.reason_phrase);
  dbms_output.put_line('Response XML:'  || cast(x_clob as varchar2));
  utl_http.end_response(http_resp) ;  
  -- x_clob response can now be used for extracting text
  -- values from specific XML nodes, using XMLExtract
end;




declare
  data varchar2(1024) := '...';
  req  utl_http.req;
  resp utl_http.resp;
begin
  req := utl_http.begin_request('http://www.psoug.org/about', 'POST');
  utl_http.set_header(req, 'Content-Length', length(data));
  -- Ask HTTP server to return "100 Continue" response
  utl_http.set_header(req, 'Expect', '100-continue');
  resp := utl_http.get_response(req, true);
  -- Check for and dispose "100 Continue" response
  if (resp.status_code <> 100) then
    utl_http.end_response(resp);
    raise_application_error(20000, 'Request rejected');
  end if;
  utl_http.end_response(resp);
  -- Now, send the request body
  utl_http.write_text(req, data);
  -- Get the regular response
  resp := utl_http.get_response(req);
  utl_http.read_text(resp, data);
  utl_http.end_response(resp);
end;



  declare
    -- Crusor que retorno os contratos para submeter os contratos digitalizados
    cursor cr_contrato_fsa is
      select pjfsa.nr_projeto_fsa,
             vw_tipo_objeto.de_tipo_objeto,
             tccon.nr_ano_chamada_publica,
             tccon.de_tipo_chamada_publica,
             -----------------------------
             vw_ppfsa.id_contrato_fsa,
             vw_ppfsa.id_proposta
        from sanfom.tmp_carga_contrato               tccon
             inner join sanfom.tb_projeto_fsa        pjfsa on (tccon.nr_projeto_fsa               = pjfsa.nr_projeto_fsa)
             inner join sanfom.tb_objeto_financiavel obfin on (pjfsa.id_projeto_fsa               = obfin.id_projeto_fsa and
                                                               substr(tccon.in_tipo_objeto, 1, 3) = obfin.in_tipo_objeto)
             inner join (select trim(regexp_substr('COM,DES,PRO', '[^,]+', 1, level)) in_tipo_objeto,
                                trim(regexp_substr('COMERCIALIZAÇÃO,' ||
                                                   'DESENVOLVIMENTO,' ||
                                                   'PRODUÇÃO', '[^,]+', 1, level)) de_tipo_objeto
                           from dual
                         connect by regexp_substr('DES,PRO,COM', '[^,]+', 1, level) is not null
                        ) vw_tipo_objeto on (obfin.in_tipo_objeto = vw_tipo_objeto.in_tipo_objeto)
             -- Recupera o ID Proposta
             inner join (select to_number(substr(lpad(replace(ppfsa.nm_proposta, 'Proposta para o Objeto Financiavel: - ', ''),  8, '0'), 1, 4)) nr_projeto_fsa,
                                substr(lpad(replace(ppfsa.nm_proposta, 'Proposta para o Objeto Financiavel: - ', ''),  8, '0'), length(lpad(replace(ppfsa.nm_proposta, 'Proposta para o Objeto Financiavel: - ', ''),  8, '0')) - 2, 3) in_tipo_objeto,
                                ctfsa.id_contrato_fsa,
                                ctfsa.id_proposta,
                                ppfsa.nr_processo_ancine
                           from sanfom.tb_proposta                ppfsa
                                inner join sanfom.tb_contrato_fsa ctfsa on (ppfsa.id_proposta = ctfsa.id_proposta)
                        ) vw_ppfsa on (tccon.nr_projeto_fsa                                                            = vw_ppfsa.nr_projeto_fsa and
                                       substr(tccon.in_tipo_objeto, 1, 3)                                              = vw_ppfsa.in_tipo_objeto and
                                       replace(replace(replace(tccon.nr_processo_ancine , '.', ''), '/', ''), '-', '') = vw_ppfsa.nr_processo_ancine)
        order by 1, 2 ,3, 4, 5, 6;
    -- Recupera o Documento Padrão carregado na tabe temporária
    cursor cr_documento is
      select * from sanfom.tmp_carga_documento;
    -- Record do tipo da linha dos cursores
    rc_contrato_fsa cr_contrato_fsa%rowtype;
    rc_documento    cr_documento%rowtype;
    -- Contadores de controle
    id_seq_aliquota    sanfom.tb_aliquota.id_aliquota%type;
    -- Variaveis para configuração do envio e retorno do XML
    xml_request   xmltype;
    xml_text      clob;
    http_request  utl_http.req;
    http_response utl_http.resp;
    txt_buffer    varchar2(1024);
    -- Variaveis com os dados do aquivo
    arquivo       sanfom.tmp_carga_documento.tx_base64%type;
    requesttoken  sanfom.tmp_carga_documento.cd_token_envio%type;
    tx_url        varchar2(1000) default 'http://10.1.124.134/guardvol/GuardVol?wsdl';
  begin
    select cd_token_envio,
           tx_base64
      into requesttoken,
           arquivo
      from sanfom.tmp_carga_documento;
    xml_request := xmltype('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:guar="http://www.ancine.gov.br/guardvol/">' || chr(13) ||
                             '<soapenv:Header/>'                                           || chr(13) ||
                               '<soapenv:Body>'                                            || chr(13) ||
                                 '<guar:guardarArquivoRequest>'                            || chr(13) ||
                                   '<arquivo>'        || arquivo      ||'</arquivo>'       || chr(13) ||
                                     '<requestToken>' || requestToken ||'</requestToken> ' || chr(13) ||
                                 '</guar:guardarArquivoRequest>'                           || chr(13) ||
                               '</soapenv:Body>'                                           || chr(13) ||
                             '</soapenv:Envelope>');
    xml_text := xml_request;
    http_request := utl_http.begin_request(url => tx_url, method => 'POST');
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
  end;


declare
  req   utl_http.req;
  resp  utl_http.resp;
  value varchar2(1024);
begin
--  utl_http.set_proxy('proxy.it.my-company.com', 'my-company.com');
  req := utl_http.begin_request('http://www-hr.corp.my-company.com');
  utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
  resp := utl_http.get_response(req);
  loop
    utl_http.read_line(resp, value, TRUE);
    dbms_output.put_line(value);
  end loop;
  utl_http.end_response(resp);
exception
  when utl_http.end_of_body then
    utl_http.end_response(resp);
end;
