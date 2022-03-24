declare
  runtime_info sys.dbms_debug.runtime_info;
  sync_result integer;
begin
  sys.dbms_debug.default_timeout := :default_timeout;
  runtime_info.program.namespace := :program_namespace;
  runtime_info.program.name := :program_name;
  runtime_info.program.owner := :program_owner;
  runtime_info.program.dblink := :program_dblink;
  runtime_info.line# := :line#;
  runtime_info.terminated := :terminated;
  runtime_info.breakpoint := :breakpoint;
  runtime_info.stackdepth := :stackdepth;
  runtime_info.interpreterdepth := :interpreterdepth;
  runtime_info.reason := :reason;
  if :do_sync = 1 then
    sync_result := sys.dbms_debug.synchronize(run_info => runtime_info,
                                              info_requested => sys.dbms_debug.info_getStackDepth +
                                                                sys.dbms_debug.info_getLineInfo +
                                                                sys.dbms_debug.info_getBreakpoint);
  end if;
  :cont_result := sys.dbms_debug.continue(run_info => runtime_info,
                                          breakflags => :breakflags,
                                          info_requested => sys.dbms_debug.info_getStackDepth +
                                                            sys.dbms_debug.info_getLineInfo +
                                                            sys.dbms_debug.info_getBreakpoint);
  :program_namespace := runtime_info.program.namespace;
  :program_name := runtime_info.program.name;
  :program_owner := runtime_info.program.owner;
  :program_dblink := runtime_info.program.dblink;
  :line# := runtime_info.line#;
  :terminated := runtime_info.terminated;
  :breakpoint := runtime_info.breakpoint;
  :stackdepth := runtime_info.stackdepth;
  :interpreterdepth := runtime_info.interpreterdepth;
  :reason := runtime_info.reason;
  sys.dbms_debug.default_timeout := 3600;
end;
