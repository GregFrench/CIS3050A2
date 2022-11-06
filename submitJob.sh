#! /bin/bash

USER=gfrench

exec 3<> /tmp/server-$USER-inputfifo;

res=""

for var in "$@"
do
    res+="$var "
done

if [ "$res" == "status" ]; then
    echo $res > /tmp/server-$USER-inputfifo;
elif [ "$res" == "shutdown" ]; then
    echo $res > /tmp/server-$USER-inputfifo;
else
    #res="CMD ${res}"
    echo $res > /tmp/server-$USER-inputfifo;
fi
