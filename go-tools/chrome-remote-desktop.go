package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"strings"
	"syscall"

	"golang.org/x/term"
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

	// Load or create config
	config, err := loadOrCreateConfig("../config.json")
	if err != nil {
		fmt.Printf("Error handling config: %v\n", err)
		os.Exit(1)
	}

	packageManager := detectPackageManager()
	distribution := detectDistribution()

	fmt.Printf("Detected distribution: %s\n", distribution)
	fmt.Printf("Detected package manager: %s\n", packageManager)

	var scriptPath string
	switch packageManager {
	case "apt":
		fmt.Println("Installing for Debian/Ubuntu based system...")
		scriptPath = "shell/apt.sh"
	case "dnf":
		fmt.Println("Installing for Red Hat/Fedora based system...")
		scriptPath = "shell/dnf.sh"
	case "pacman":
		fmt.Println("Installing for Arch Linux based system...")
		scriptPath = "shell/pacman.sh"
	case "zypper":
		fmt.Println("Installing for openSUSE based system...")
		scriptPath = "shell/zypper.sh"
	default:
		fmt.Println("Error: Unsupported package manager or Linux distribution")
		fmt.Println("This script supports the following distributions:")
		fmt.Println("- Debian/Ubuntu (apt)")
		fmt.Println("- Red Hat/Fedora (dnf)")
		fmt.Println("- Arch Linux (pacman)")
		fmt.Println("- openSUSE (zypper)")
		os.Exit(1)
	}

	// Set environment variables for shell script to use
	os.Setenv("CONFIG_USERNAME", config.User.Username)
	os.Setenv("CONFIG_PASSWORD", config.User.Password)

	cmd := exec.Command("bash", scriptPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		fmt.Printf("Error running installation script: %v\n", err)
		os.Exit(1)
	}
}

func loadOrCreateConfig(configPath string) (*Config, error) {
	if _, err := os.Stat(configPath); err == nil {
		return loadConfig(configPath)
	}

	fmt.Println("config.json not found. Creating one now...")
	return createConfig(configPath)
}

func loadConfig(configPath string) (*Config, error) {
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file: %w", err)
	}

	var config Config
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %w", err)
	}

	fmt.Printf("Using username from config.json: %s\n", config.User.Username)
	return &config, nil
}

func createConfig(configPath string) (*Config, error) {
	fmt.Println("Please enter the following details:")

	fmt.Print("Enter username: ")
	reader := bufio.NewReader(os.Stdin)
	username, err := reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("failed to read username: %w", err)
	}
	username = strings.TrimSpace(username)

	fmt.Print("Enter password: ")
	passwordBytes, err := term.ReadPassword(int(syscall.Stdin))
	if err != nil {
		return nil, fmt.Errorf("failed to read password: %w", err)
	}
	fmt.Println()

	config := &Config{
		User: UserConfig{
			Username: username,
			Password: string(passwordBytes),
		},
	}

	data, err := json.MarshalIndent(config, "", "  ")
	if err != nil {
		return nil, fmt.Errorf("failed to marshal config: %w", err)
	}

	if err := os.WriteFile(configPath, data, 0600); err != nil {
		return nil, fmt.Errorf("failed to write config file: %w", err)
	}

	fmt.Println("config.json created successfully!")
	return config, nil
}

func isRoot() bool {
	currentUser, err := user.Current()
	if err != nil {
		return false
	}
	return currentUser.Uid == "0"
}

func detectPackageManager() string {
	managers := []string{"apt", "dnf", "pacman", "zypper"}

	for _, manager := range managers {
		if _, err := exec.LookPath(manager); err == nil {
			return manager
		}
	}

	return "unknown"
}

func detectDistribution() string {
	file, err := os.Open("/etc/os-release")
	if err != nil {
		return "Unknown Distribution"
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "NAME=") {
			name := strings.TrimPrefix(line, "NAME=")
			name = strings.Trim(name, `"`)
			return name
		}
	}

	return "Unknown Distribution"
}
