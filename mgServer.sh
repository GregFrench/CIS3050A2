#! /bin/bash
export PATH=.:$PATH

USER=gfrench
terminate=1
if [ ! -p /tmp/server-$USER-inputfifo ] ; then 
    mkfifo /tmp/server-$USER-inputfifo
fi

echo "Starting up `cat /proc/cpuinfo | grep processor | wc -l` processing units"
echo "Ready for processing : place tasks into /tmp/server-${USER}-fifo"

while [ $terminate != 0 ]
do
    if read line; then
        echo $line
        # terminate=0
    fi
done </tmp/server-$USER-inputfifo
