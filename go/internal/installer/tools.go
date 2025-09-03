package installer

import (
	"chrome-remote-desktop-installer/internal/platform"
	"chrome-remote-desktop-installer/pkg/downloader"
	"fmt"
	"os"
	"os/exec"
)

const (
	chromeURL = "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
	vscodeURL = "https://packages.microsoft.com/repos/code/pool/main/c/code/code_1.85.1-1702462158_amd64.deb"
)

type ToolsInstaller struct {
	dist *platform.Distribution
}

func NewToolsInstaller(dist *platform.Distribution) *ToolsInstaller {
	return &ToolsInstaller{dist: dist}
}

func (t *ToolsInstaller) InstallChrome() error {
	fmt.Println("Installing Google Chrome...")

	switch t.dist.PackageManager {
	case platform.APT:
		debFile := "/tmp/google-chrome-stable_current_amd64.deb"

		if err := downloader.DownloadFile(chromeURL, debFile); err != nil {
			return fmt.Errorf("failed to download Chrome: %w", err)
		}
		defer os.Remove(debFile)

		return t.runCommands(
			[]string{"dpkg", "-i", debFile},
			[]string{"apt", "--fix-broken", "install", "-y"},
		)
	case platform.DNF:
		return t.runCommands(
			[]string{"dnf", "install", "-y", "google-chrome-stable"},
		)
	case platform.PACMAN:
		return fmt.Errorf("Chrome installation via AUR not implemented")
	case platform.ZYPPER:
		return t.runCommands(
			[]string{"zypper", "install", "-y", "google-chrome-stable"},
		)
	default:
		return fmt.Errorf("Chrome installation not supported for %s", t.dist.PackageManager)
	}
}

func (t *ToolsInstaller) InstallVSCode() error {
	fmt.Println("Installing Visual Studio Code...")

	switch t.dist.PackageManager {
	case platform.APT:
		debFile := "/tmp/code_current_amd64.deb"

		if err := downloader.DownloadFile(vscodeURL, debFile); err != nil {
			return fmt.Errorf("failed to download VS Code: %w", err)
		}
		defer os.Remove(debFile)

		return t.runCommands(
			[]string{"dpkg", "-i", debFile},
			[]string{"apt", "--fix-broken", "install", "-y"},
		)
	case platform.DNF:
		return t.runCommands(
			[]string{"rpm", "--import", "https://packages.microsoft.com/keys/microsoft.asc"},
			[]string{"sh", "-c", "echo -e '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc' > /etc/yum.repos.d/vscode.repo"},
			[]string{"dnf", "install", "-y", "code"},
		)
	case platform.PACMAN:
		return t.runCommands(
			[]string{"pacman", "-S", "--noconfirm", "code"},
		)
	case platform.ZYPPER:
		return t.runCommands(
			[]string{"rpm", "--import", "https://packages.microsoft.com/keys/microsoft.asc"},
			[]string{"zypper", "addrepo", "https://packages.microsoft.com/yumrepos/vscode", "vscode"},
			[]string{"zypper", "refresh"},
			[]string{"zypper", "install", "-y", "code"},
		)
	default:
		return fmt.Errorf("VS Code installation not supported for %s", t.dist.PackageManager)
	}
}

func (t *ToolsInstaller) runCommands(commands ...[]string) error {
	for _, cmdArgs := range commands {
		cmd := exec.Command(cmdArgs[0], cmdArgs[1:]...)
		if err := cmd.Run(); err != nil {
			return fmt.Errorf("command failed: %s: %w", cmdArgs, err)
		}
	}
	return nil
}
