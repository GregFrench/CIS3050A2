#! /bin/bash
USER=gfrench
terminate=1
ID=$1

if [ $# -eq 0 ]
  then
    echo "No worker ID supplied"
    exit 1
fi

if [ ! -p /tmp/worker-$ID-$USER-inputfifo ] ; then 
    mkfifo -m 077 /tmp/worker-$ID-$USER-inputfifo
fi

count=0
while [ $terminate != 0 ]
do
    if read line; then
        if [ "$line" == "shutdown" ]; then
            rm /tmp/worker-$ID-$USER-inputfifo
            exit 0
        fi

        if [ $count -eq 0 ]; then
            $line > /tmp/worker-$USER.$ID.log
        else
            $line >> /tmp/worker-$USER.$ID.log
        fi

        count=$(($count+1))

        if [[ -p /tmp/server-${USER}-inputfifo ]]; then
            echo "ready ${ID}" > /tmp/server-${USER}-inputfifo &
        fi
    fi
done </tmp/worker-$ID-$USER-inputfifo
