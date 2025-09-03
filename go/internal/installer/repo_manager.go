package installer

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

type RepoManager struct{}

func NewRepoManager() *RepoManager {
	return &RepoManager{}
}

func (r *RepoManager) CloneFavoriteRepos() error {
	fmt.Println("Cloning all favorite repositories...")

	repos := []string{
		"https://github.com/microsoft/vscode.git",
		"https://github.com/golang/go.git",
		"https://github.com/kubernetes/kubernetes.git",
		"https://github.com/docker/docker.git",
		"https://github.com/hashicorp/terraform.git",
	}

	reposDir := "/root/repositories"
	if err := os.MkdirAll(reposDir, 0755); err != nil {
		return fmt.Errorf("failed to create repositories directory: %w", err)
	}

	for _, repo := range repos {
		fmt.Printf("Cloning %s...\n", repo)
		cmd := exec.Command("git", "clone", repo)
		cmd.Dir = reposDir
		if err := cmd.Run(); err != nil {
			fmt.Printf("Warning: Failed to clone %s: %v\n", repo, err)
			continue
		}
	}

	return nil
}

func (r *RepoManager) BrowseAndCloneRepos() error {
	fmt.Println("Starting interactive repository browser...")

	cmd := exec.Command("bash", "-c", `
		echo "Enter repository URLs to clone (one per line, empty line to finish):"
		while true; do
			read -p "Repository URL: " repo_url
			if [ -z "$repo_url" ]; then
				break
			fi
			echo "Cloning $repo_url..."
			git clone "$repo_url" /root/repositories/$(basename "$repo_url" .git) 2>/dev/null || echo "Failed to clone $repo_url"
		done
	`)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func (r *RepoManager) ListClonedRepos() error {
	fmt.Println("Listing cloned repositories...")

	reposDir := "/root/repositories"

	if _, err := os.Stat(reposDir); os.IsNotExist(err) {
		fmt.Println("No repositories directory found. Clone some repositories first.")
		return nil
	}

	entries, err := os.ReadDir(reposDir)
	if err != nil {
		return fmt.Errorf("failed to read repositories directory: %w", err)
	}

	fmt.Printf("\nRepositories in %s:\n", reposDir)
	fmt.Println("===========================================")

	for _, entry := range entries {
		if entry.IsDir() {
			repoPath := filepath.Join(reposDir, entry.Name())

			cmd := exec.Command("git", "remote", "get-url", "origin")
			cmd.Dir = repoPath
			output, err := cmd.Output()
			if err != nil {
				fmt.Printf("%-30s | %s\n", entry.Name(), "Not a git repository")
			} else {
				fmt.Printf("%-30s | %s", entry.Name(), string(output))
			}
		}
	}

	return nil
}
