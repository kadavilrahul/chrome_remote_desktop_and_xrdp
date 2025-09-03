package config

import (
	"encoding/json"
	"fmt"
	"os"
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

func LoadOrCreateConfig(configPath string) (*Config, error) {
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
	var username string
	fmt.Scanln(&username)

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
