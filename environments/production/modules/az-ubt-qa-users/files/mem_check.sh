#!/bin/bash
mtotal=`egrep 'MemTotal' /proc/meminfo | awk '{print $2}'`
mused=`egrep 'Active:' /proc/meminfo | awk '{print $2}'`
mpercent=`echo "scale=2; $mused / $mtotal * 100" | bc | cut -d "." -f1`
skpid=$(ps aux | grep sidekiq | grep company-webservice | awk '{print $2}')

if [ -n "${skpid}" ]; then

        if [ $mpercent -ge 15 ]; then
                echo "Memory consumption GREATER than 85%, running restart"
                kill -9 $skpid
                cd /opt/company-webservice
                bundle exec sidekiq -e test &

        else
                echo "Memory consumption OK"
        fi

else
        echo "Starting sidekiq execution"
        cd /opt/company-webservice
        bundle exec sidekiq -e test&
fi
