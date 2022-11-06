#! /bin/bash

USER=gfrench
terminate=1
pipe=/tmp/server-$USER-inputfifo

## Setup signal trap
trap 'trap " " SIGINT SIGKILL; kill 0; wait; sigterm_handler' SIGINT SIGKILL

if [ ! -p $pipe ] ; then 
    mkfifo $pipe
fi

numWorkers=`cat /proc/cpuinfo | grep processor | wc -l`
workers=()
worker=0

echo "Starting up ${numWorkers} processing units"

sigterm_handler() { 
    i=0
    while [ $i -ne $numWorkers ]
    do
        i=$(($i+1))
        echo "shutdown" > /tmp/worker-$i-$USER-inputfifo &
    done

    exit 1
}

i=0
while [ $i -ne $numWorkers ]
do
    i=$(($i+1))
    ./worker.sh $i &
    workers+=(1)
done

echo "Ready for processing : place tasks into /tmp/server-${USER}-fifo"

while [ $terminate != 0 ]
do
    if read line; then
        echo $line
        str="$line"
        set -- $str
        firstWord=$1

        if [[ "$firstWord" == "shutdown" ]]; then
            sigterm_handler
            terminate=0
        elif [[ "$firstWord" == "ready" ]]; then
            echo "id:"
            ID=$(echo $line | cut -d " " -f2-)
            echo $ID
            workers[$(($ID-1))]=1
        else
            if [[ workers[$(($worker-1))] -eq 1 ]]; then
                echo "go"
                echo $line | cut -d " " -f2- > /tmp/worker-$(($worker+1))-$USER-inputfifo;
                workers[$(($worker-1))]=0
                worker=$(($worker+1))
                worker=$(($worker%$numWorkers))
            else
                echo $line > /tmp/server-$USER-inputfifo;
            fi
        fi
    fi
done <$pipe
