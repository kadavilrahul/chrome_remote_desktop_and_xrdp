package installer

import (
	"fmt"
	"os"
	"os/exec"
)

type SystemConfigInstaller struct{}

func NewSystemConfigInstaller() *SystemConfigInstaller {
	return &SystemConfigInstaller{}
}

func (s *SystemConfigInstaller) SetTimezone() error {
	fmt.Println("Setting timezone to Asia/Kolkata...")

	cmd := exec.Command("timedatectl", "set-timezone", "Asia/Kolkata")
	return cmd.Run()
}

func (s *SystemConfigInstaller) SetupAliases() error {
	fmt.Println("Setting up command aliases...")

	aliases := `
# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias h='history'
alias c='clear'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias myip='curl http://ipecho.net/plain; echo'
alias logs='journalctl -f'
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias info='apt info'
`

	bashrcPath := "/root/.bashrc"
	file, err := os.OpenFile(bashrcPath, os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("failed to open .bashrc: %w", err)
	}
	defer file.Close()

	_, err = file.WriteString(aliases)
	if err != nil {
		return fmt.Errorf("failed to write aliases: %w", err)
	}

	fmt.Println("Aliases added to .bashrc successfully!")
	fmt.Println("Run 'source ~/.bashrc' or restart your terminal to use the new aliases.")

	return nil
}
