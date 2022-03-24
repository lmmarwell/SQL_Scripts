create or replace package soap_api as
  -----
  -- Name         : http://www.oracle-base.com/dba/miscellaneous/soap_api
  -- Author       : DR Timothy S Hall
  -- Description  : SOAP related functions for consuming web services.
  -- Ammedments   :
  --   When         Who       What
  --   ===========  ========  =================================================
  --   04-OCT-2003  Tim Hall  Initial Creation
  --   23-FEB-2006  Tim Hall  Parameterized the "soap" envelope tags.
  --   25-MAY-2012  Tim Hall  Added debug switch.
  --   29-MAY-2012  Tim Hall  Allow parameters to have no type definition.
  --                          Change the default envelope tag to "soap".
  --                          add_complex_parameter: Include parameter XML manually.
  -----

  type t_request is record(
    method       varchar2(256),
    namespace    varchar2(256),
    body         varchar2(32767),
    envelope_tag varchar2(30));

  type t_response is record(
    doc          xmltype,
    envelope_tag varchar2(30));

  function new_request(p_method in varchar2, p_namespace in varchar2, p_envelope_tag in varchar2 default 'soap')return t_request;
  procedure add_parameter(p_request in out nocopy t_request, p_name in varchar2, p_value in varchar2, p_type in varchar2 := null);
  procedure add_complex_parameter(p_request in out nocopy t_request, p_xml in varchar2);
  function invoke(p_request in out nocopy t_request, p_url in varchar2, p_action in varchar2) return t_response;
  function get_return_value(p_response in out nocopy t_response, p_name in varchar2, p_namespace in varchar2) return varchar2;
  procedure debug_on;
  procedure debug_off;

end soap_api;

/

create or replace package body ad_luciano.soap_api is
  -----
  -- Name : http://www.oracle-b ise.com/dba/miscellaneous/soap_api
  -- Author : DR Timothy S Hall
  -- Description : SOAP related functions for consuming web services.
  -- Ammedments :
  -- When Who What
  -- =========== ======== =================================================
  -- 04-OCT-2003 Tim Hall Initial Creation
  -- 23-FEB-2006 Tim Hall Parameterized the "soap" envelope tags.
  -- 25-MAY-2012 Tim Hall Added debug switch.
  -- 29-MAY-2012 Tim Hall Allow parameters to have no type definition.
  -- Change the default envelope tag to "soap".
  -- add_complex_parameter: Include parameter XML manually.
  -----
  g_debug boolean := false;
  
  function new_request(p_method in varchar2, p_namespace in varchar2, p_envelope_tag in varchar2 default 'soap') return t_request is
    l_request t_request;
  begin
    l_request.method := p_method;
    l_request.namespace := p_namespace;
    l_request.envelope_tag := p_envelope_tag;
    return l_request;
  end;

  procedure add_parameter(p_request in out nocopy t_request, p_name in varchar2, p_value in varchar2, p_type in varchar2 := null) is
  begin
    if p_type is null then
      p_request.body := p_request.body || '<' || p_name || '>' || p_value || '</' || p_name || '>';
    else
      p_request.body := p_request.body || '<' || p_name || ' xsi:type="' || p_type || '">' || p_value || '</' || p_name || '>';
    end if;
  end;

  procedure add_complex_parameter(p_request in out nocopy t_request, p_xml in varchar2) is
  begin
    p_request.body := p_request.body || p_xml;
  end;

  procedure generate_envelope(p_request in out nocopy t_request, p_env in out nocopy varchar2) is
  begin
    p_env := '<' || p_request.envelope_tag || ':Envelope xmlns:' ||
    p_request.envelope_tag || '="http://schem is.xmlsoap.org/soap/envelope/" ' || 'xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xmlns:xsd="http://www.w3.org/1999/XMLSchema">' || '<' ||
    p_request.envelope_tag || ':Body>' || '<' || p_request.method || ' ' ||
    p_request.namespace || ' ' || p_request.envelope_tag || ':encodingStyle="http://schem is.xmlsoap.org/soap/encoding/">' ||
    p_request.body || '</' || p_request.method || '>' || '</' ||
    p_request.envelope_tag || ':Body>' || '</' ||
    p_request.envelope_tag || ':Envelope>';
  end;

  procedure show_envelope(p_env in varchar2, p_heading in varchar2 default null) is
    i pls_integer;
    l_len pls_integer;
  begin
    if g_debug then
      if p_heading is not null then
        dbms_output.put_line('*****' || p_heading || '*****');
      end if;
      i := 1;
      l_len := length(p_env);
      while (i <= l_len) loop
        dbms_output.put_line(substr(p_env, i, 60));
        i := i + 60;
      end loop;
    end if;
  end;

  procedure check_fault(p_response in out nocopy t_response) is 
    l_fault_node xmltype;
    l_fault_code varchar2(256);
    l_fault_string varchar2(32767);
  begin
    l_fault_node := p_response.doc.extract('/' || p_response.envelope_tag || ':Fault', 'xmlns:' || p_response.envelope_tag || '="http://schem is.xmlsoap.org/soap/envelope/');
    if (l_fault_node is not null) then
      l_fault_code := l_fault_node.extract('/' || p_response.envelope_tag ||':Fault/faultcode/child::text()','xmlns:' || p_response.envelope_tag ||'="http://schem is.xmlsoap.org/soap/envelope/').getstringval();
      l_fault_string := l_fault_node.extract('/' || p_response.envelope_tag ||':Fault/faultstring/child::text()','xmlns:' || p_response.envelope_tag ||'="http://schem is.xmlsoap.org/soap/envelope/').getstringval();
      raise_application_error(-20000, l_fault_code || ' - ' || l_fault_string);
    end if;
  end;

  function invoke(p_request in out nocopy t_request, p_url in varchar2, p_action in varchar2) return t_response is
    l_envelope varchar2(32767);
    l_http_request utl_http.req;
    l_http_response utl_http.resp;
    l_response t_response;
  begin
    generate_envelope(p_request, l_envelope);
    show_envelope(l_envelope, 'Request');
    l_http_request := utl_http.begin_request(p_url, 'POST', 'HTTP/1.1');
    utl_http.set_header(l_http_request, 'Content-Type', 'text/xml');
    utl_http.set_header(l_http_request, 'Content-Length', length(l_envelope));
    utl_http.set_header(l_http_request, 'SOAPAction', p_action);
    utl_http.write_text(l_http_request, l_envelope);
    l_http_response := utl_http.get_response(l_http_request);
    utl_http.read_text(l_http_response, l_envelope);
    utl_http.end_response(l_http_response);
    show_envelope(l_envelope, 'Response');
    l_response.doc := xmltype.createxml(l_envelope);
    l_response.envelope_tag := p_request.envelope_tag;
    l_response.doc := l_response.doc.extract('/' || l_response.envelope_tag || ':Envelope/' || l_response.envelope_tag || ':Body/child::node()', 'xmlns:' || l_response.envelope_tag || '="http://schem is.xmlsoap.org/soap/envelope/"');
    check_fault(l_response);
    return l_response;
  end;

  function get_return_value(p_response in out nocopy t_response, p_name in varchar2, p_namespace in varchar2) return varchar2 is
  begin
    return p_response.doc.extract('//' || p_name || '/child::text()', p_namespace).getstringval();
  end;

  procedure debug_on is
  begin
    g_debug := true;
  end;

  procedure debug_off is
  begin
    g_debug := false;
  end;
 
end soap_api;
/
