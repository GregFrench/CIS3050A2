#! /bin/bash

# First test case
./submitJob.sh ls -l &

# Second test case
./submitJob.sh ./timedCountdown.sh 10 &

echo "Waiting for jobs to finish..."

# sleep for 12 seconds
sleep 12

# Third test case
./submitJob.sh -s &

sleep 1

# Fourth test case
./submitJob.sh -x &
