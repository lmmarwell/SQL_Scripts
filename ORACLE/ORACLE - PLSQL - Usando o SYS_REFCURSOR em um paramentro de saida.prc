procedure proc_usuario(p_nuusuario in varchar2, p_cursor out sys_refcursor) is
begin
	open p_cursor for select * from usuario where nuusuario = p_nuusuario;
exception
	when no_data_found then null;
end;
