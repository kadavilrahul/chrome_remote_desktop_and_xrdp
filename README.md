# This repository is to install XFCE and Chrome Remote desktop on Ubuntu using shellscript

Description:
1. This code installs XFCE and Chrome remote desktop
2. The purpose of the installation is to install Graphical user interface on Linux server and access server desktop from remote location, mobile phones etc.

Advantages of this method:
1. This makes it easy for installtion and usage of softwares that need graphical interface like browsers, code editors and others.
2. You can cccess host terminal of the server and run commands there which is faster than SSH.
3. Run terminal commands from web browser, mobile phone, tablets etc. 

Process:
1. Open Linux terminal
2. Login with user root and password for root
3. Clone this repository to your server
4. Go to the repository folder with command "cd chrome_remote_desktop_ubuntu"
5. Edit file with command "sudo nano install_chrome_remote_desktop.sh"
6. Edit line numbers 23, 24 in the file to enter your username and password. NEW_USER="-----------" USER_PASSWORD="-------------"
7. Run the shell script with command "bash install_chrome_remote_desktop.sh"
8. Logout of root
9. Login with the new username and password created in step 6
10. Install Chrome remote desktop extension on your browser
11. Go to "Setup via SSH" > Set up another computer > begin > next > authorize > Debian Linux > Copy the command
12. Paste the command copied from chrome remote desktop and paste on the linux terminal and enter to run.
13. Enter pin
14. The remote dektop connection should now be running.
15. Go to Remote access om chrome remote desktop and see if you can access the server.

Tested on:    Linux Ubuntu 24.04.1 LTS


