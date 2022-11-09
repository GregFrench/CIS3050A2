#! /bin/bash

USER=gfrench
terminate=1
pipe=/tmp/server-$USER-inputfifo

if [ ! -p $pipe ] ; then 
    mkfifo -m 077 $pipe
fi

numWorkers=`cat /proc/cpuinfo | grep processor | wc -l`
workers=()
queue=()
worker=0
numProcessed=0

echo "Starting up ${numWorkers} processing units"

shutdownHandler() {
    i=0
    while [ $i -ne $numWorkers ]
    do
        i=$(($i+1))
        echo "shutdown" > /tmp/worker-$i-$USER-inputfifo &
    done

    rm /tmp/server-gfrench-inputfifo

    exit 1
}

processJob() {
    # retrieve first item of queue
    item=${queue[0]}

    # pop element from queue
    queue=("${queue[@]:1}")

    echo $item | cut -d " " -f2- > /tmp/worker-$(($worker+1))-$USER-inputfifo;
    workers[$(($worker))]=0
    worker=$(($worker+1))
    worker=$(($worker%$numWorkers))
}

trap 'shutdownHandler' SIGINT

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
        str="$line"
        set -- $str
        firstWord=$1

        if [[ "$line" == "shutdown" ]]; then
            terminate=0
        elif [[ "$firstWord" == "status" ]]; then
            echo "Number of workers: ${numWorkers}"
            echo "Number of tasks processed: ${numProcessed}"
        elif [[ "$firstWord" == "ready" ]]; then
            ID=$(echo $line | cut -d " " -f2-)
            workers[$(($ID-1))]=1
            numProcessed=$(($numProcessed+1))

            if [ ${#queue[@]} -gt 0 ]; then
                processJob
            fi
        else
            queue+=("$line")

            if [[ workers[$(($worker))] -eq 1 ]]; then
                processJob
            fi
        fi
    fi
done <$pipe

shutdownHandler
