package platform

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type PackageManager string

const (
	APT     PackageManager = "apt"
	DNF     PackageManager = "dnf"
	PACMAN  PackageManager = "pacman"
	ZYPPER  PackageManager = "zypper"
	UNKNOWN PackageManager = "unknown"
)

type Distribution struct {
	Name           string
	PackageManager PackageManager
}

func DetectDistribution() (*Distribution, error) {
	osRelease, err := parseOSRelease()
	if err != nil {
		return nil, fmt.Errorf("failed to detect distribution: %w", err)
	}

	pkgMgr := detectPackageManager()

	return &Distribution{
		Name:           osRelease["NAME"],
		PackageManager: pkgMgr,
	}, nil
}

func detectPackageManager() PackageManager {
	managers := map[string]PackageManager{
		"apt":    APT,
		"dnf":    DNF,
		"pacman": PACMAN,
		"zypper": ZYPPER,
	}

	for cmd, mgr := range managers {
		if _, err := exec.LookPath(cmd); err == nil {
			return mgr
		}
	}

	return UNKNOWN
}

func parseOSRelease() (map[string]string, error) {
	file, err := os.Open("/etc/os-release")
	if err != nil {
		return nil, err
	}
	defer file.Close()

	osInfo := make(map[string]string)
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			continue
		}

		key := strings.TrimSpace(parts[0])
		value := strings.Trim(strings.TrimSpace(parts[1]), `"`)
		osInfo[key] = value
	}

	return osInfo, scanner.Err()
}

func (pm PackageManager) String() string {
	return string(pm)
}

func (pm PackageManager) IsSupported() bool {
	return pm != UNKNOWN
}
