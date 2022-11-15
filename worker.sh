#! /bin/bash
USER=gfrench
terminate=1
ID=$1
worker=/tmp/worker-$ID-$USER-inputfifo

if [ $# -eq 0 ]
  then
    echo "No worker ID supplied"
    exit 1
fi

# create the worker fifo if none exists
if [ ! -p $worker ] ; then 
    mkfifo -m 770 $worker
fi

# waits for messages from the worker fifo
count=0
while [ $terminate != 0 ]
do
    if read line; then
        # handles shutdown command
        if [ "$line" == "shutdown" ]; then
            rm $worker
            exit 0
        fi

        # replaces log file if writing for the first time.
        # otherwise, it appends to it
        if [ $count -eq 0 ]; then
            $line > /tmp/worker-$USER.$ID.log
        else
            $line >> /tmp/worker-$USER.$ID.log
        fi

        count=$(($count+1))

        # sends message to the server saying it is ready for new commands
        if [[ -p /tmp/server-${USER}-inputfifo ]]; then
            echo "ready ${ID}" > /tmp/server-${USER}-inputfifo &
        fi
    fi
done <$worker
