package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"os/user"
)

type UserConfig struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type Config struct {
	User UserConfig `json:"user"`
}

func main() {
	if !isRoot() {
		fmt.Println("Please run as root (use sudo)")
		os.Exit(1)
	}

	// Check if config.json exists (for consistency)
	if _, err := os.Stat("config.json"); err == nil {
		config, err := loadConfig("config.json")
		if err == nil {
			fmt.Printf("Using username from config.json: %s\n", config.User.Username)
		}
	}

	fmt.Println("Installing Visual Studio Code...")

	cmd := exec.Command("bash", "shell/vscode.sh")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		fmt.Printf("Error running VS Code installation script: %v\n", err)
		os.Exit(1)
	}
}

func loadConfig(configPath string) (*Config, error) {
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, err
	}

	var config Config
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, err
	}

	return &config, nil
}

func isRoot() bool {
	currentUser, err := user.Current()
	if err != nil {
		return false
	}
	return currentUser.Uid == "0"
}
