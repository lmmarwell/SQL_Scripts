select /*+ ordered */
 w1.sid waiting_session,
 h1.sid holding_session,
 w.kgllktype lock_or_pin,
 w.kgllkhdl address,
 decode(h.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive', 'Unknown') mode_held,
 decode(w.kgllkreq, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive', 'Unknown') mode_requested
  from dba_kgllock w, dba_kgllock h, v$session w1, v$session h1
 where (((h.kgllkmod != 0) and (h.kgllkmod != 1) and
       ((h.kgllkreq = 0) or (h.kgllkreq = 1))) and
       (((w.kgllkmod = 0) or (w.kgllkmod = 1)) and
       ((w.kgllkreq != 0) and (w.kgllkreq != 1))))
   and w.kgllktype = h.kgllktype
   and w.kgllkhdl = h.kgllkhdl
   and w.kgllkuse = w1.saddr
   and h.kgllkuse = h1.saddr;

select to_name from v$object_dependency where to_address = 'C00000009BD00170';

select * from v$object_dependency

select distinct kglnaobj
  from x$kgllk
 where kgllkuse in (select saddr from v$session where sid = 16);
select distinct kglnaobj
  from x$kgllk
 where kgllkuse in (select saddr from v$session where sid = 18);

select username, terminal, osuser, program from v$session where sid = 42;
