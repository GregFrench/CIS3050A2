#! /bin/bash

USER=gfrench

exec 3<> /tmp/server-$USER-inputfifo;

res=""

count=0
for var in "$@"
do
    if [[ count -gt 0 ]]; then
        res+="$var "
    else
        res+="$var"
    fi

    count=$(($count+1))
done

if [[ "$res" == "status" ]]; then
    echo $res > /tmp/server-$USER-inputfifo;
elif [[ "$res" == "shutdown" ]]; then
    echo $res > /tmp/server-$USER-inputfifo;
else
    res="CMD ${res}"
    echo $res > /tmp/server-$USER-inputfifo;
fi
