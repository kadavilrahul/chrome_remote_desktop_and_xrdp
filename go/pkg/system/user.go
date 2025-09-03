package system

import (
	"fmt"
	"os/exec"
	"os/user"
)

func CreateUser(username, password string) error {
	if err := addUser(username); err != nil {
		return fmt.Errorf("failed to add user: %w", err)
	}

	if err := setPassword(username, password); err != nil {
		return fmt.Errorf("failed to set password: %w", err)
	}

	if err := addToSudoGroup(username); err != nil {
		return fmt.Errorf("failed to add user to sudo group: %w", err)
	}

	if err := addToChromeRemoteDesktopGroup(username); err != nil {
		return fmt.Errorf("failed to add user to chrome-remote-desktop group: %w", err)
	}

	return nil
}

func addUser(username string) error {
	cmd := exec.Command("adduser", "--disabled-password", "--gecos", "", username)
	return cmd.Run()
}

func setPassword(username, password string) error {
	cmd := exec.Command("bash", "-c", fmt.Sprintf("echo '%s:%s' | chpasswd", username, password))
	return cmd.Run()
}

func addToSudoGroup(username string) error {
	cmd := exec.Command("usermod", "-aG", "sudo", username)
	return cmd.Run()
}

func addToChromeRemoteDesktopGroup(username string) error {
	if err := createChromeRemoteDesktopGroup(); err != nil {
		return err
	}

	cmd := exec.Command("usermod", "-aG", "chrome-remote-desktop", username)
	return cmd.Run()
}

func createChromeRemoteDesktopGroup() error {
	cmd := exec.Command("groupadd", "chrome-remote-desktop")
	err := cmd.Run()
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 9 {
			return nil
		}
		return err
	}
	return nil
}

func IsRoot() bool {
	currentUser, err := user.Current()
	if err != nil {
		return false
	}
	return currentUser.Uid == "0"
}

func SwitchToUser(username string) error {
	cmd := exec.Command("su", "-", username)
	cmd.Stdin = nil
	cmd.Stdout = nil
	cmd.Stderr = nil
	return cmd.Start()
}
