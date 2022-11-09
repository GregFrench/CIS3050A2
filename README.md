# CIS*3050 Assignment 2

Name: Greg French
Student ID: 1084574

These commands should be run first to ensure that the shell scripts are executable:
chmod +x mgServer.sh
chmod +x submitJob.sh
chmod +x worker.sh
chmod +x runtests.sh
chmod +x timedCountdown.sh

To run the server:
./mgServer.sh

To submit a job:
./submitJob.sh ls -l

To run tests (Assuming mgServer is running):
./runtests.sh

Overview of how the program works along with the details for each test case are located in the A2report.pdf file.

Todo:
- wait for worker to finish before sending it new message
- add permissions to the pipes
- Should the server write command back to itself if it can't execute a command because all workers are busy?
- Add 0077 permissions to fifo's
