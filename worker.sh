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
    mkfifo /tmp/worker-$ID-$USER-inputfifo
fi

echo "ready" > /tmp/worker-$ID-$USER-inputfifo;

while [ $terminate != 0 ]
do
    if read line; then
        echo $line > /tmp/worker-$USER.$ID.log
        echo "ready" > /tmp/worker-$ID-$USER-inputfifo;
    fi
done </tmp/worker-$ID-$USER-inputfifo
