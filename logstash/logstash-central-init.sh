#! /bin/sh

# From The Logstash Book
# The original of this file can be found at: http://logstashbook.com/code/index.html
#

### BEGIN INIT INFO
# Provides:          logstash
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

. /lib/lsb/init-functions

name="logstash-central"
logstash_bin="/opt/logstash/bin/logstash"
logstash_conf="/etc/logstash/central.conf"
logstash_log="/var/log/logstash/central.log"
pid_file="/var/run/$name.pid"
cwd=`pwd`

start () {
        command="${logstash_bin} agent --verbose -f $logstash_conf --log $logstash_log"

        log_daemon_msg "Starting $name"
        if start-stop-daemon --start --quiet --oknodo -d /opt/logstash/ --pidfile "$pid_file" -b -m -N 19 --exec $command; then
                log_end_msg 0
        else
                log_end_msg 1
        fi
}

stop () {
        log_daemon_msg "Stopping $name"
        start-stop-daemon --stop --quiet --oknodo --pidfile "$pid_file"
}

status () {
        status_of_proc -p $pid_file "" "$name"
}

case $1 in
        start)
                if status; then exit 0; fi
                start
                ;;
        stop)
                stop
                ;;
        reload)
                stop
                sleep 2
                start
                ;;
        restart)
                stop
                sleep 2
                start
                ;;
        status)
                status && exit 0 || exit $?
                ;;
        *)
                echo "Usage: $0 {start|stop|restart|reload|status}"
                exit 1
                ;;
esac

exit 0
