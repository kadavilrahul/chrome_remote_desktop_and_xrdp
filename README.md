# rclone_ubuntu
Install XFCE and Chrome Remote desktop on Ubuntu using shellscript

Description:
1. This code installs XFCE and Chrome remote desktop
2. The purpose of the installation is to install Graphical user interface on Linux server and access server desktop from remote location
3. This makes it easy for installtion and usage of softwares that need graphical interface, browsers, code editors and others.

Process:
1. Open Linux terminal
2. Login with user root and password for root
3. Clone this repository by typing below command on terminal and enter
git clone https://github.com/kadavilrahul/rclone_ubuntu.git
4. Go to the repository folder
cd rclone_ubuntu
5.Edit file install_chrome_remote_desktop.sh
sudo nano install_chrome_remote_desktop.sh
6.Edit lines 23, 24 to enter your username and password.
NEW_USER="-----------"
USER_PASSWORD="-------------"
7. Run the shell script with below command
bash install_chrome_remote_desktop.sh
8. Logout of root
9. Login with the new username and password created in step 5.
19. Install Chrome remote desktop extension on your browser
11. Go to "Setup via SSH" > Set up another computer > begin > next > authorize > Debian Linux > Copy the command
12. Paste the command copied from chrome remote desktop and paste on the linux terminal and enter to run.
13. Enter pin
14. The remote dektop connection should now be running.
15. Go to Remote access om chrome remote desktop and see if you can access the server.

Tested on:    Linux Ubuntu 24.04.1 LTS


