#! /bin/bash

# First test case
./submitJob.sh ls -l &

# Second test case
./submitJob.sh ./timedCountdown.sh 10 &

# Third test case
./submitJob.sh ls | sort --ignore-case &

# Fourth test case
./submitJob.sh ./timedCountdown.sh 5 &

# Fifth test case
./submitJob.sh ls | sort -r --ignore-case &

# Sixth test case
./submitJob.sh ./timedCountdown.sh 5 &

echo "Waiting for jobs to finish..."

# sleep for 12 seconds
sleep 12

# Seventh test case
./submitJob.sh -s &

sleep 1

# Eighth test case
./submitJob.sh -x &
