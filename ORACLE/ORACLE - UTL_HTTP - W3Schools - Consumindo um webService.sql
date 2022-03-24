declare
  l_celsius           varchar2(128) default '10'; -- Celsius is passed here 
  v_soap_request      xmltype default xmltype('<?xml version="1.0" encoding="utf-8"?>' || chr(13) ||
                                              '<soap12:envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' || chr(13) ||
                                              '  <soap12:Body>' || chr(13) ||
                                              '    <celsiustofahrenheit xmlns="http://www.w3schools.com/webservices/">' || chr(13) ||
                                              '      <Celsius>' || l_celsius || '</Celsius>' || chr(13) ||
                                              '    </celsiustofahrenheit>' || chr(13) ||
                                              '  </soap12:Body>' || chr(13) ||
                                              '</soap12:Envelope>');
  v_soap_request_text clob default v_soap_request.getclobval();
  v_request           utl_http.req;
  v_response          utl_http.resp;
  v_buffer            varchar2(1024);
begin
  v_request := utl_http.begin_request(url    => 'https://www.w3schools.com/xml/tempconvert.asm',
                                      method => 'POST');  
  utl_http.set_header(v_request, 'User-Agent', 'Mozilla/4.0');
  v_request.method := 'POST';
  utl_http.set_header (r     => v_request,
                       name  => 'Content-Length',
                       value => dbms_lob.getlength(v_soap_request_text));
  utl_http.write_text (r    => v_request,
                       data => v_soap_request_text);
  v_response := utl_http.get_response(v_request);
  loop
    utl_http.read_line(v_response, v_buffer, true); 
    dbms_output.put_line(v_buffer);  
  end loop;  
  utl_http.end_response(v_response);
exception
  when utl_http.end_of_body then  
    utl_http.end_response(v_response);
end;


declare
  l_http_request        utl_http.req;
  l_http_response       utl_http.resp;
  l_buffer_size         number(10) default 512;
  l_line_size           number(10) default 50;
  l_lines_count         number(10) default 20;
  l_string_request      varchar2(512);
  l_line                varchar2(128);
  l_substring_msg       varchar2(512);
  l_raw_data            raw(512);
  l_clob_response       clob;
  l_host_name           varchar2(128) default 'www.w3schools.com';
  l_celsius             varchar2(128) default '10'; -- Celsius is passed here 
  l_resp_xml            xmltype;
  l_result_xml_node     varchar2(128);
  l_namespace_soap      varchar2(128) default 'xmlns="http://www.w3.org/2003/05/soap-envelope"';
  l_response_fahrenheit varchar2(128);
begin
  l_string_request := '<?xml version="1.0" encoding="utf-8"?>' || chr(13) ||
                      '<soap12:envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' || chr(13) ||
                      '  <soap12:Body>' || chr(13) ||
                      '    <celsiustofahrenheit xmlns="http://www.w3schools.com/webservices/">' || chr(13) ||
                      '      <Celsius>' || l_celsius || '</Celsius>' || chr(13) ||
                      '    </celsiustofahrenheit>' || chr(13) ||
                      '  </soap12:Body>' || chr(13) ||
                      '</soap12:Envelope>';
  utl_http.set_transfer_timeout(60);
  l_http_request := utl_http.begin_request(url          => 'https://www.w3schools.com/xml/tempconvert.asmx',
                                           method       => 'POST',
                                           http_version => 'HTTP/1.1');
  utl_http.set_header(l_http_request, 'User-Agent',     'Mozilla/4.0');
  utl_http.set_header(l_http_request, 'Connection',     'close');
  utl_http.set_header(l_http_request, 'Content-Type',   'application/soap+xml; charset=utf-8');
  utl_http.set_header(l_http_request, 'Content-Length', length(l_string_request));
  
  <<request_loop>>
  for i in 0 .. (ceil(length(l_string_request) / l_buffer_size) - 1) loop
    l_substring_msg := substr(l_string_request, (i * l_buffer_size + 1), l_buffer_size);
    begin
      l_raw_data := utl_raw.cast_to_raw(l_substring_msg);
      utl_http.write_raw(r    => l_http_request,
                         data => l_raw_data);
    exception
      when no_data_found then exit request_loop;
    end;
  end loop request_loop;
  l_http_response := utl_http.get_response(l_http_request);
  dbms_output.put_line('Response> status_code...: "' || l_http_response.status_code   || '"');
  dbms_output.put_line('Response> reason_phrase.: "' || l_http_response.reason_phrase || '"');
  dbms_output.put_line('Response> http_version..: "' || l_http_response.http_version  || '"');
  begin
    <<response_loop>>
    loop
      utl_http.read_raw(l_http_response, l_raw_data, l_buffer_size);
      l_clob_response := l_clob_response || utl_raw.cast_to_varchar2(l_raw_data);
    end loop response_loop;
  exception
    when utl_http.end_of_body then utl_http.end_response(l_http_response);
  end;
  
  
  if (l_http_response.status_code = 200) then
    -- Create XML type from response text
    l_resp_xml := xmltype.createxml(l_clob_response);
    -- Clean SOAP header
    select extract(l_resp_xml ,'Envelope/Body/node()' ,l_namespace_soap)
      into l_resp_xml
      from dual;      
    -- Extract Fahrenheit value 
    l_result_xml_node := '/CelsiusToFahrenheitResponse/CelsiusToFahrenheitResult';
    dbms_output.put_line('Response from w3schools webservices:');
    select extractvalue(l_resp_xml ,l_result_xml_node ,'xmlns="http://www.w3schools.com/webservices/"')
      into l_response_fahrenheit
      from dual;
  end if;
  dbms_output.put_line(l_celsius || ' Celsius =  ' || l_response_fahrenheit || ' Fahrenheit');
  if l_http_request.private_hndl is not null then
    utl_http.end_request(l_http_request);
  end if;
  if l_http_response.private_hndl is not null then
    utl_http.end_response(l_http_response);
  end if;  
  commit;
end;
