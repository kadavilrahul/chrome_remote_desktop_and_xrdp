package installer

import (
	"fmt"
	"os/exec"
)

type DevToolsInstaller struct{}

func NewDevToolsInstaller() *DevToolsInstaller {
	return &DevToolsInstaller{}
}

func (d *DevToolsInstaller) InstallGitHubCLI() error {
	fmt.Println("Installing GitHub CLI...")

	cmd := exec.Command("bash", "-c", `
		type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
		sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
		sudo apt update
		sudo apt install gh -y
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallOpenCode() error {
	fmt.Println("Installing OpenCode Editor...")

	cmd := exec.Command("bash", "-c", `
		curl -fsSL https://download.opencode.io/install.sh | sh
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) LoginOpenCode() error {
	fmt.Println("Launching OpenCode login...")

	cmd := exec.Command("opencode", "auth", "login")
	cmd.Stdin = nil
	cmd.Stdout = nil
	cmd.Stderr = nil
	return cmd.Start()
}

func (d *DevToolsInstaller) InstallGeminiCLI() error {
	fmt.Println("Installing Gemini CLI...")

	cmd := exec.Command("bash", "-c", `
		curl -fsSL https://install.gemini.google.com/cli | bash
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallCLOC() error {
	fmt.Println("Installing CLOC (Count Lines of Code)...")

	cmd := exec.Command("apt", "install", "-y", "cloc")
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallNodeJS() error {
	fmt.Println("Installing Node.js & npm...")

	cmd := exec.Command("bash", "-c", `
		curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
		sudo apt-get install -y nodejs
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallZoxide() error {
	fmt.Println("Installing Zoxide (smart cd replacement)...")

	cmd := exec.Command("bash", "-c", `
		curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallGCloudCLI() error {
	fmt.Println("Installing Google Cloud CLI...")

	cmd := exec.Command("bash", "-c", `
		curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
		echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
		sudo apt-get update && sudo apt-get install google-cloud-cli
	`)
	return cmd.Run()
}

func (d *DevToolsInstaller) InstallAllBasicTools() error {
	fmt.Println("Installing all basic development tools...")

	tools := []func() error{
		d.InstallOpenCode,
		d.InstallGeminiCLI,
		d.InstallCLOC,
		d.InstallNodeJS,
		d.InstallZoxide,
	}

	for _, tool := range tools {
		if err := tool(); err != nil {
			return fmt.Errorf("failed to install tool: %w", err)
		}
	}

	return nil
}
