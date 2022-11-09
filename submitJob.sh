#! /bin/bash

USER=gfrench
res=""

count=0
for var in "$@"
do
    if (( count > 0 )); then
        res="$res $var"
    else
        res="$var"
    fi

    count=$(($count+1))
done

if [[ "$res" == "-s" ]]; then
    res="status"
    echo $res > /tmp/server-$USER-inputfifo;
elif [[ "$res" == "-x" ]]; then
    res="shutdown"
    echo $res > /tmp/server-$USER-inputfifo;
else
    res="CMD $res"
    echo $res > /tmp/server-$USER-inputfifo;
fi
