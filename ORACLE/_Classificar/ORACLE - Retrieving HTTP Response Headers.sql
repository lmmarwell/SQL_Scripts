declare 
  x utl_http.html_pieces;
begin
  -- utl_http.set_proxy('http://iwsvahqt/proxy.pac', 'http://www.oracle.com');
	x := utl_http.request_pieces('http://www.oracle.com/');
  dbms_output.put_line(x.count || ' pieces were retrieved.');
  dbms_output.put_line('with total length ');
  if x.count < 1 then
		dbms_output.put_line('0');
  else
		dbms_output.put_line((2000 * (x.count - 1)) + length(x(x.count)));
  end if;
end;


declare
  req   utl_http.req;
  resp  utl_http.resp;
  name  varchar2(256);
  value varchar2(1024);
begin
  req := utl_http.begin_request('http://www.oracle.com/');
  utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
  resp := utl_http.get_response(req);
  dbms_output.put_line('HTTP response status code: ' || resp.status_code);
  dbms_output.put_line('HTTP response reason phrase: ' || resp.reason_phrase);
  for i in 1..utl_http.get_header_count(resp) loop
    utl_http.get_header(resp, i, name, value);
    dbms_output.put_line(name || ': ' || value);
  end loop;
  utl_http.end_response(resp);
end;
