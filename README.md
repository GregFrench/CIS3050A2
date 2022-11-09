# CIS*3050 Assignment 2

Name: Greg French
Student ID: 1084574

To run:
./mgServer.sh

To run tests (Assuming mgServer is running):
./runtests.sh

Overview of how the program works along with the details for each test case are located in the A2report.pdf file.

Todo:
- get mgServer to run without sh as ./mgServer
- get submitJob to run as submitJob rather than ./submitJob.sh
- assume that mgServer is run before run tests?
- todo: shutdown and status
- wait for worker to finish before sending it new message
- add permissions to the pipes
- Should the server write command back to itself if it can't execute a command because all workers are busy?
- Add data structure to store commands that need to be executed in a worker when it becomes free