create or replace procedure show_url(url in varchar2, username in varchar2 default null, password in varchar2 default null) as
	req       utl_http.req;
	resp      utl_http.resp;
	name      varchar2(256);
	value     varchar2(1024);
	data      varchar2(255);
	my_scheme varchar2(256);
	my_realm  varchar2(256);
	my_proxy  boolean;
begin
	-- when going through a firewall, pass requests through this host.
	-- specify sites inside the firewall that don't need the proxy host.
--	utl_http.set_proxy('proxy.my-company.com', 'corp.my-company.com');
	-- ask utl_http not to raise an exception for 4xx and 5xx status codes,
	-- rather than just returning the text of the error page.
	utl_http.set_response_error_check(false);
	-- begin retrieving this web page.
	req := utl_http.begin_request(url);
	-- identify ourselves. some sites serve special pages for particular browsers.
	utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
	-- specify a user id and password for pages that require them.
	if (username is not null) then
		utl_http.set_authentication(req, username, password);
	end if;
	begin
		-- start receiving the html text.
		resp := utl_http.get_response(req);
		-- show the status codes and reason phrase of the response.
		dbms_output.put_line('HTTP response status code: ' || resp.status_code);
		dbms_output.put_line('HTTP response reason phrase: ' || resp.reason_phrase);
		-- look for client-side error and report it.
		if (resp.status_code >= 400) and (resp.status_code <= 499) then
			-- detect whether the page is password protected, and we didn't supply
			-- the right authorization.
			if (resp.status_code = utl_http.http_unauthorized) then
				utl_http.get_authentication(resp, my_scheme, my_realm, my_proxy);
				if (my_proxy) then
					dbms_output.put_line('Web proxy server is protected.');
					dbms_output.put('Please supply the required ' || my_scheme ||
													' authentication username/password for realm ' || my_realm ||
													' for the proxy server.');
				else
					dbms_output.put_line('Web page ' || url || ' is protected.');
					dbms_output.put('Please supplied the required ' || my_scheme ||
													' authentication username/password for realm ' || my_realm ||
													' for the Web page.');
				end if;
			else
				dbms_output.put_line('Check the URL.');
			end if;
			utl_http.end_response(resp);
			return;
			-- look for server-side error and report it.
		elsif (resp.status_code >= 500) and (resp.status_code <= 599) then
			dbms_output.put_line('Check if the Web site is up.');
			utl_http.end_response(resp);
			return;
		end if;
    -- the http header lines contain information about cookies, character sets,
		-- and other data that client and server can use to customize each session.
		for i in 1..utl_http.get_header_count(resp) loop
			utl_http.get_header(resp, i, name, value);
			dbms_output.put_line(name || ': ' || value);
		end loop;
		-- keep reading lines until no more are left and an exception is raised.
		loop
			utl_http.read_line(resp, value);
			dbms_output.put_line(value);
		end loop;
	exception
		when utl_http.end_of_body then
			utl_http.end_response(resp);
	end;
end;
