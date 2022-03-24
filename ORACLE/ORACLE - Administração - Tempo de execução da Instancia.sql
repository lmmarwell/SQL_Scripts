select trunc(sysdate - min(startup_time)) days,
			 trunc((sysdate - min(startup_time) -
						 trunc(sysdate - min(startup_time))) * 24) hours,
			 trunc(((sysdate - min(startup_time) -
						 trunc(sysdate - min(startup_time))) * 24 -
						 trunc((sysdate - min(startup_time) -
										trunc(sysdate - min(startup_time))) * 24)) * 60)
	from v$instance
