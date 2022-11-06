#! /bin/bash

USER=gfrench
terminate=1
pipe=/tmp/server-$USER-inputfifo

sigterm_handler() { 
    i=0
    while [ $i -ne $numWorkers ]
    do
        i=$(($i+1))
        echo "remove";
        rm "/tmp/worker-$i-$USER-inputfifo"
    done

    exit 1
}

## Setup signal trap
trap 'trap " " SIGINT SIGKILL; kill 0; wait; sigterm_handler' SIGINT SIGKILL

if [ ! -p $pipe ] ; then 
    mkfifo $pipe
fi

numWorkers=`cat /proc/cpuinfo | grep processor | wc -l`
arr=()

echo "Starting up ${numWorkers} processing units"

i=0
while [ $i -ne $numWorkers ]
do
    i=$(($i+1))
    ./worker.sh $i &
    arr+=($!)
done

echo "Ready for processing : place tasks into /tmp/server-${USER}-fifo"

while [ $terminate != 0 ]
do
    if read line; then
        echo $line
        echo $line > /tmp/worker-1-$USER-inputfifo;
        # terminate=0
    fi
done <$pipe