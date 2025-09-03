package installer

import (
	"chrome-remote-desktop-installer/internal/config"
	"chrome-remote-desktop-installer/internal/platform"
	"chrome-remote-desktop-installer/pkg/downloader"
	"chrome-remote-desktop-installer/pkg/system"
	"fmt"
	"os"
	"os/exec"
)

const (
	chromeRemoteDesktopURL = "https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
	xfceSessionConfig      = "exec /etc/X11/Xsession /usr/bin/xfce4-session"
)

type ChromeRemoteDesktopInstaller struct {
	dist   *platform.Distribution
	config *config.Config
}

func NewChromeRemoteDesktopInstaller(dist *platform.Distribution, cfg *config.Config) *ChromeRemoteDesktopInstaller {
	return &ChromeRemoteDesktopInstaller{
		dist:   dist,
		config: cfg,
	}
}

func (c *ChromeRemoteDesktopInstaller) Install() error {
	fmt.Printf("Detected distribution: %s\n", c.dist.Name)
	fmt.Printf("Detected package manager: %s\n", c.dist.PackageManager)

	if !c.dist.PackageManager.IsSupported() {
		return fmt.Errorf("unsupported package manager: %s", c.dist.PackageManager)
	}

	if err := c.updateSystem(); err != nil {
		return fmt.Errorf("failed to update system: %w", err)
	}

	if err := c.installChromeRemoteDesktop(); err != nil {
		return fmt.Errorf("failed to install Chrome Remote Desktop: %w", err)
	}

	if err := c.installDesktopEnvironment(); err != nil {
		return fmt.Errorf("failed to install desktop environment: %w", err)
	}

	if err := c.configureDesktopSession(); err != nil {
		return fmt.Errorf("failed to configure desktop session: %w", err)
	}

	if err := c.setupUser(); err != nil {
		return fmt.Errorf("failed to setup user: %w", err)
	}

	c.printInstructions()
	return nil
}

func (c *ChromeRemoteDesktopInstaller) updateSystem() error {
	fmt.Println("Updating system packages...")

	switch c.dist.PackageManager {
	case platform.APT:
		return c.runCommands(
			[]string{"apt", "update"},
			[]string{"apt", "upgrade", "-y"},
		)
	case platform.DNF:
		return c.runCommands(
			[]string{"dnf", "update", "-y"},
		)
	case platform.PACMAN:
		return c.runCommands(
			[]string{"pacman", "-Syu", "--noconfirm"},
		)
	case platform.ZYPPER:
		return c.runCommands(
			[]string{"zypper", "update", "-y"},
		)
	}

	return nil
}

func (c *ChromeRemoteDesktopInstaller) installChromeRemoteDesktop() error {
	fmt.Println("Installing Chrome Remote Desktop...")

	switch c.dist.PackageManager {
	case platform.APT:
		debFile := "/tmp/chrome-remote-desktop_current_amd64.deb"

		if err := downloader.DownloadFile(chromeRemoteDesktopURL, debFile); err != nil {
			return err
		}
		defer os.Remove(debFile)

		return c.runCommands(
			[]string{"dpkg", "-i", debFile},
			[]string{"apt", "--fix-broken", "install", "-y"},
			[]string{"apt", "--fix-missing", "install", "-y"},
		)
	default:
		return fmt.Errorf("Chrome Remote Desktop installation not implemented for %s", c.dist.PackageManager)
	}
}

func (c *ChromeRemoteDesktopInstaller) installDesktopEnvironment() error {
	fmt.Println("Installing desktop environment...")

	switch c.dist.PackageManager {
	case platform.APT:
		return c.runCommands(
			[]string{"apt", "install", "-y", "xfce4", "xfce4-goodies"},
			[]string{"apt", "install", "-y", "lightdm"},
			[]string{"apt", "install", "-y", "firefox"},
		)
	case platform.DNF:
		return c.runCommands(
			[]string{"dnf", "install", "-y", "xfce4-session", "xfce4-settings", "xfce4-panel"},
			[]string{"dnf", "install", "-y", "lightdm"},
			[]string{"dnf", "install", "-y", "firefox"},
		)
	case platform.PACMAN:
		return c.runCommands(
			[]string{"pacman", "-S", "--noconfirm", "xfce4", "xfce4-goodies"},
			[]string{"pacman", "-S", "--noconfirm", "lightdm"},
			[]string{"pacman", "-S", "--noconfirm", "firefox"},
		)
	case platform.ZYPPER:
		return c.runCommands(
			[]string{"zypper", "install", "-y", "xfce4-session"},
			[]string{"zypper", "install", "-y", "lightdm"},
			[]string{"zypper", "install", "-y", "firefox"},
		)
	}

	return nil
}

func (c *ChromeRemoteDesktopInstaller) configureDesktopSession() error {
	fmt.Println("Configuring desktop session...")

	return os.WriteFile("/etc/chrome-remote-desktop-session", []byte(xfceSessionConfig), 0644)
}

func (c *ChromeRemoteDesktopInstaller) setupUser() error {
	fmt.Println("Setting up user...")

	return system.CreateUser(c.config.User.Username, c.config.User.Password)
}

func (c *ChromeRemoteDesktopInstaller) runCommands(commands ...[]string) error {
	for _, cmdArgs := range commands {
		cmd := exec.Command(cmdArgs[0], cmdArgs[1:]...)
		if err := cmd.Run(); err != nil {
			return fmt.Errorf("command failed: %s: %w", cmdArgs, err)
		}
	}
	return nil
}

func (c *ChromeRemoteDesktopInstaller) printInstructions() {
	fmt.Println("\nInstallation complete.")
	fmt.Printf("You are now being logged in as %s.\n", c.config.User.Username)
	fmt.Println("Install Chrome remote desktop extension on your browser")
	fmt.Println("Open and go to Setup via")
	fmt.Println("SSH > Set up another computer > begin > next > authorize > Debian Linux > Copy command")
	fmt.Println("Paste the command copied from chrome remote desktop here and enter")
	fmt.Println("Enter pin")
	fmt.Println("The remote desktop connection should now be running")
}
