#! /bin/bash

USER=gfrench
terminate=1
pipe=/tmp/server-$USER-inputfifo

# create the server fifo if none exists
if [ ! -p $pipe ] ; then 
    mkfifo -m 770 $pipe
fi

numWorkers=`cat /proc/cpuinfo | grep processor | wc -l`
workers=()
queue=()
worker=0
numProcessed=0

echo "Starting up ${numWorkers} processing units"

# handles graceful shutdown of the system
shutdownHandler() {
    i=0
    while [ $i -ne $numWorkers ]
    do
        i=$(($i+1))
        echo "shutdown" > /tmp/worker-$i-$USER-inputfifo &
    done

    rm /tmp/server-gfrench-inputfifo

    exit 0
}

# process a job when a worker is ready
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

# spawn the workers
i=0
while [ $i -ne $numWorkers ]
do
    i=$(($i+1))
    ./worker.sh $i &
    workers+=(1)
done

echo "Ready for processing : place tasks into /tmp/server-${USER}-fifo"

# waits for messages from the server fifo
while [ $terminate != 0 ]
do
    if read line; then
        str="$line"
        set -- $str
        firstWord=$1

        # handles the shutdown command
        if [[ "$line" == "shutdown" ]]; then
            terminate=0
        # handles the status command
        elif [[ "$firstWord" == "status" ]]; then
            echo "Number of workers: ${numWorkers}"
            echo "Number of tasks processed: ${numProcessed}"
        # handles message from a worker when it has finished their task
        elif [[ "$firstWord" == "ready" ]]; then
            ID=$(echo $line | cut -d " " -f2-)
            workers[$(($ID-1))]=1
            numProcessed=$(($numProcessed+1))

            if [ ${#queue[@]} -gt 0 ]; then
                processJob
            fi
        # handles executable command messages
        else
            queue+=("$line")

            if [[ workers[$(($worker))] -eq 1 ]]; then
                processJob
            fi
        fi
    fi
done <$pipe

shutdownHandler
