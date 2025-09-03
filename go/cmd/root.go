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
	menu := ui.NewMenu("Chrome Remote Desktop Setup Menu")

	menu.AddItem(1, "Auto-detect and install Chrome Remote Desktop", func() error {
		installer := installer.NewChromeRemoteDesktopInstaller(dist, cfg)
		return installer.Install()
	})

	menu.AddItem(2, "Install Google Chrome Browser", func() error {
		toolsInstaller := installer.NewToolsInstaller(dist)
		return toolsInstaller.InstallChrome()
	})

	menu.AddItem(3, "Install Visual Studio Code", func() error {
		toolsInstaller := installer.NewToolsInstaller(dist)
		return toolsInstaller.InstallVSCode()
	})

	menu.AddItem(4, "Setup xRDP", func() error {
		return fmt.Errorf("xRDP setup not implemented yet")
	})

	return menu.Show()
}
