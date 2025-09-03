package installer

import (
	"fmt"
	"os/exec"
	"os/user"
)

type SSHHelper struct{}

func NewSSHHelper() *SSHHelper {
	return &SSHHelper{}
}

func (s *SSHHelper) ShowWindowsPowerShellCommand() error {
	fmt.Println("SSH Command for Windows PowerShell:")
	fmt.Println("====================================")

	// Get current hostname/IP
	cmd := exec.Command("hostname", "-I")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("ssh root@YOUR_SERVER_IP")
	} else {
		ip := string(output)
		fmt.Printf("ssh root@%s", ip)
	}

	fmt.Println("\nReplace YOUR_SERVER_IP with your actual server IP address")
	fmt.Println("You can also use: ssh root@$(curl -s ifconfig.me)")

	return nil
}

func (s *SSHHelper) ShowLinuxMacCommand() error {
	fmt.Println("SSH Command for Linux/Mac Terminal:")
	fmt.Println("====================================")

	// Get current hostname/IP
	cmd := exec.Command("hostname", "-I")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("ssh root@YOUR_SERVER_IP")
	} else {
		ip := string(output)
		fmt.Printf("ssh root@%s", ip)
	}

	fmt.Println("\nFor local connections:")
	fmt.Println("ssh root@localhost")
	fmt.Println("ssh root@127.0.0.1")

	return nil
}

func (s *SSHHelper) ShowNonRootToRootCommand() error {
	fmt.Println("SSH from Non-root to root@localhost:")
	fmt.Println("====================================")

	currentUser, err := user.Current()
	if err != nil {
		fmt.Println("su - root")
		fmt.Println("sudo su -")
	} else {
		if currentUser.Uid == "0" {
			fmt.Println("You are already root user!")
			return nil
		}

		fmt.Printf("Current user: %s\n", currentUser.Username)
		fmt.Println("\nTo switch to root:")
		fmt.Println("su - root")
		fmt.Println("sudo su -")
		fmt.Println("sudo -i")

		fmt.Println("\nTo SSH as root to localhost:")
		fmt.Println("ssh root@localhost")
		fmt.Println("ssh root@127.0.0.1")
	}

	return nil
}
