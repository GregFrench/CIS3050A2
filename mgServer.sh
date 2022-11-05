#! /bin/bash
USER=gfrench
terminate=1
pipe=/tmp/server-$USER-inputfifo
if [ ! -p $pipe ] ; then 
    mkfifo $pipe
fi

numWorkers=`cat /proc/cpuinfo | grep processor | wc -l`

echo "Starting up ${numWorkers} processing units"

i=0
while [ $i -ne $numWorkers ]
do
    i=$(($i+1))
    ./worker.sh $i &
done

echo "Ready for processing : place tasks into /tmp/server-${USER}-fifo"

while [ $terminate != 0 ]
do
    if read line; then
        echo $line
        # terminate=0
    fi
done <$pipe
