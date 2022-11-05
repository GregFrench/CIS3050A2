#! /bin/bash

USER=gfrench

exec 3<> /tmp/server-$USER-inputfifo;

res=""

for var in "$@"
do
    res+="$var "
done

echo $res > /tmp/server-$USER-inputfifo;
