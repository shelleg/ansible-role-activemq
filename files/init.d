#!/bin/bash
#
# activemq       Starts ActiveMQ.
#
#
# chkconfig: 345 88 12
# description: ActiveMQ is a JMS Messaging Queue Server.
### BEGIN INIT INFO
# Provides: activemq
### END INIT INFO

## Source function library.
. /etc/rc.d/init.d/functions
# Source LSB function library.
if [ -r /lib/lsb/init-functions ]; then
    . /lib/lsb/init-functions
else
    exit 1
fi

DISTRIB_ID=`lsb_release -i -s 2>/dev/null`

NAME="$(basename $0)"
unset ISBOOT
if [ "${NAME:0:1}" = "S" -o "${NAME:0:1}" = "K" ]; then
    NAME="${NAME:3}"
    ISBOOT="1"
fi

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
    SU="/sbin/runuser"
else
    SU="/bin/su"
fi

. /etc/sysconfig/activemq

RETVAL=0

umask 077

start() {
       echo -n $"Starting ActiveMQ: "
       $SU - $ACTIVEMQ_USER -c "${ACTIVEMQ_START}" >> $ACTIVEMQ_LOG 2>&1 &
       RETVAL="$?"
       if [ "$RETVAL" -eq 0 ]; then
          log_success_msg
          touch /var/lock/subsys/${NAME}
       else
          log_failure_msg
       fi

       return $RETVAL
}
stop() {
       pkill -u activemq java
}
restart() {
       stop
       sleep 5
       start
}
case "$1" in
 start)
       start
       ;;
 stop)
       stop
       ;;
 restart|reload)
       restart
       ;;
 *)
       echo $"Usage: $0 {start|stop|restart}"
       exit 1
esac

exit $?
