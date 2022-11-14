#! /bin/bash

echo "Submitting jobs..."

# First test case
./submitJob.sh ls -l &

echo "Submitting job 1"

sleep 1

# Second test case
./submitJob.sh ./timedCountdown.sh 10 &

echo "Submitting job 2"

sleep 1

# Third test case
./submitJob.sh ls | sort --ignore-case &

echo "Submitting job 3"

sleep 1

# Fourth test case
./submitJob.sh ./timedCountdown.sh 5 &

echo "Submitting job 4"

sleep 1

# Fifth test case
./submitJob.sh ls | sort -r --ignore-case &

echo "Submitting job 5"

sleep 1

# Sixth test case
./submitJob.sh ./timedCountdown.sh 2 &

echo "Submitting job 6"

sleep 1

# Seventh test case
./submitJob.sh echo "Hello, World" &

echo "Submitting job 7"

sleep 1

# Eighth test case
./submitJob.sh pwd &

echo "Submitting job 8"

sleep 1

# Ninth test case
./submitJob.sh ls &

echo "Submitting job 9"

sleep 1

# Tenth test case
./submitJob.sh ls -F &

echo "Submitting job 10"

sleep 1

echo "Waiting for jobs to finish..."

# sleep for 12 seconds
sleep 12

# Eleventh test case
./submitJob.sh -s &

echo "Getting status"

sleep 1

# Twelfth test case
./submitJob.sh -x &

echo "Shutting down"

sleep 1

echo "Finished running tests"
