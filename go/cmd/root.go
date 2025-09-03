package cmd

import (
	"chrome-remote-desktop-installer/internal/config"
	"chrome-remote-desktop-installer/internal/installer"
	"chrome-remote-desktop-installer/internal/platform"
	"chrome-remote-desktop-installer/internal/ui"
	"chrome-remote-desktop-installer/pkg/system"
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "chrome-remote-desktop-installer",
	Short: "Chrome Remote Desktop installer for multiple Linux distributions",
	Long:  "An automated installer for Chrome Remote Desktop that works across different Linux distributions with an interactive menu interface.",
	RunE:  runInteractiveMenu,
}

var (
	configFile    string
	autoInstall   bool
	installChrome bool
	installVSCode bool
)

func init() {
	rootCmd.PersistentFlags().StringVar(&configFile, "config", "config.json", "Config file path")
	rootCmd.Flags().BoolVar(&autoInstall, "auto", false, "Auto-install Chrome Remote Desktop")
	rootCmd.Flags().BoolVar(&installChrome, "chrome", false, "Install Google Chrome")
	rootCmd.Flags().BoolVar(&installVSCode, "vscode", false, "Install Visual Studio Code")
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

func runInteractiveMenu(cmd *cobra.Command, args []string) error {
	if !system.IsRoot() {
		return fmt.Errorf("this program requires root privileges. Please run with sudo")
	}

	dist, err := platform.DetectDistribution()
	if err != nil {
		return fmt.Errorf("failed to detect distribution: %w", err)
	}

	if !dist.PackageManager.IsSupported() {
		return fmt.Errorf("unsupported package manager: %s. Supported: apt, dnf, pacman, zypper", dist.PackageManager)
	}

	cfg, err := config.LoadOrCreateConfig(configFile)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if autoInstall {
		return runAutoInstall(dist, cfg)
	}

	if installChrome {
		return runChromeInstall(dist)
	}

	if installVSCode {
		return runVSCodeInstall(dist)
	}

	return runMenu(dist, cfg)
}

func runAutoInstall(dist *platform.Distribution, cfg *config.Config) error {
	installer := installer.NewChromeRemoteDesktopInstaller(dist, cfg)
	return installer.Install()
}

func runChromeInstall(dist *platform.Distribution) error {
	toolsInstaller := installer.NewToolsInstaller(dist)
	return toolsInstaller.InstallChrome()
}

func runVSCodeInstall(dist *platform.Distribution) error {
	toolsInstaller := installer.NewToolsInstaller(dist)
	return toolsInstaller.InstallVSCode()
}

func runMenu(dist *platform.Distribution, cfg *config.Config) error {
	menu := ui.NewMenu("Server Setup Go - System Configuration Tool")

	devTools := installer.NewDevToolsInstaller()
	systemConfig := installer.NewSystemConfigInstaller()
	repoManager := installer.NewRepoManager()
	sshHelper := installer.NewSSHHelper()

	// Development Tools Installation
	menu.AddItem(1, "Install GitHub CLI", "./run.sh gh-install", "Required for repo management", func() error {
		return devTools.InstallGitHubCLI()
	})

	menu.AddItem(2, "Install OpenCode Editor", "./run.sh opencode-install", "AI-powered code assistant", func() error {
		return devTools.InstallOpenCode()
	})

	menu.AddItem(3, "Login to OpenCode", "./run.sh opencode-login", "Authenticate with OpenCode", func() error {
		return devTools.LoginOpenCode()
	})

	menu.AddItem(4, "Install Gemini CLI", "./run.sh gemini-install", "Google Gemini AI CLI", func() error {
		return devTools.InstallGeminiCLI()
	})

	menu.AddItem(5, "Install CLOC", "./run.sh cloc-install", "Count lines of code", func() error {
		return devTools.InstallCLOC()
	})

	menu.AddItem(6, "Install Node.js & npm", "./run.sh nodejs-install", "JavaScript runtime", func() error {
		return devTools.InstallNodeJS()
	})

	menu.AddItem(7, "Install Zoxide", "./run.sh zoxide-install", "Smart cd replacement", func() error {
		return devTools.InstallZoxide()
	})

	menu.AddItem(8, "Install Google Cloud CLI", "./run.sh gcloud-install", "GCP management tool", func() error {
		return devTools.InstallGCloudCLI()
	})

	menu.AddItem(9, "Install All Basic Tools", "./run.sh basic-all", "OpenCode, Gemini, CLOC, Node.js, Zoxide", func() error {
		return devTools.InstallAllBasicTools()
	})

	// System Configuration
	menu.AddItem(10, "Set Timezone (Asia/Kolkata)", "./run.sh timezone-set", "Configure system timezone", func() error {
		return systemConfig.SetTimezone()
	})

	menu.AddItem(11, "Setup Command Aliases", "./run.sh aliases-setup", "Add convenient shortcuts", func() error {
		return systemConfig.SetupAliases()
	})

	// Repository Management
	menu.AddItem(12, "Clone All Favorites", "./run.sh repo-favorites", "Clone all favorite repositories", func() error {
		return repoManager.CloneFavoriteRepos()
	})

	menu.AddItem(13, "Browse & Clone Repos", "./run.sh repo-clone-all", "Clone repos", func() error {
		return repoManager.BrowseAndCloneRepos()
	})

	menu.AddItem(14, "Show Cloned Repositories", "./run.sh repo-list", "List local repos", func() error {
		return repoManager.ListClonedRepos()
	})

	// SSH Connection Commands
	menu.AddItem(15, "SSH for Windows PowerShell", "./run.sh ssh-powershell", "Windows SSH command", func() error {
		return sshHelper.ShowWindowsPowerShellCommand()
	})

	menu.AddItem(16, "SSH for Linux/Mac Terminal", "./run.sh ssh-linux", "Unix SSH command", func() error {
		return sshHelper.ShowLinuxMacCommand()
	})

	menu.AddItem(17, "SSH Non-root to root@localhost", "./run.sh ssh-nonroot", "Local root access", func() error {
		return sshHelper.ShowNonRootToRootCommand()
	})

	return menu.Show()
}
