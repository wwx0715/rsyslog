#!/bin/bash
# added 2018-10-24 by Rainer Gerhards
# This is part of the rsyslog testbench, licensed under ASL 2.0
. ${srcdir:=.}/diag.sh init
generate_conf
add_conf '
global(operatingStateFile="'$RSYSLOG_DYNNAME.osf'")
action(type="omfile" file="'$RSYSLOG_OUT_LOG'")
'

# create an unclean file
err_osf_content=""
printf '%s' "$err_osf_content" > $RSYSLOG_DYNNAME.osf
startup
shutdown_when_empty # shut down rsyslogd when done processing messages
wait_shutdown	# we need to wait until rsyslogd is finished!

check_file_exists "$RSYSLOG_DYNNAME.osf.previous"
check_file_exists "$RSYSLOG_DYNNAME.osf"
content_check "this may be an indication of a problem, e.g. empty file" "$RSYSLOG_OUT_LOG"
content_check "CLEAN CLOSE" "$RSYSLOG_DYNNAME.osf"
exit_test
