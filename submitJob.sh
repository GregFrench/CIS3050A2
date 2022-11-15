#! /bin/bash

USER=gfrench
res=""

# parses command from the user
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

# send status command
if [[ "$res" == "-s" ]]; then
    res="status"
    echo $res > /tmp/server-$USER-inputfifo;
# send shutdown command
elif [[ "$res" == "-x" ]]; then
    res="shutdown"
    echo $res > /tmp/server-$USER-inputfifo;
# send executable command
else
    res="CMD $res"
    echo $res > /tmp/server-$USER-inputfifo;
fi
