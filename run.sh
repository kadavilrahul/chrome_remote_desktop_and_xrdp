#!/bin/bash

# Colors for better visual appearance
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to draw a box around text
draw_box() {
    local text="$1"
    local length=${#text}
    local padding=4
    local total_width=$((length + padding))

    printf "${CYAN}╔"
    for ((i=0; i<total_width; i++)); do printf "═"; done
    printf "╗${NC}\n"

    printf "${CYAN}║  %-${length}s  ║${NC}\n" "$text"

    printf "${CYAN}╚"
    for ((i=0; i<total_width; i++)); do printf "═"; done
    printf "╝${NC}\n"
}

# Function to display the main menu
show_menu() {
    clear
    echo
    echo "Chrome Remote Desktop Setup Menu"
    echo
    echo "Choose an option:"
    echo

    echo "=== GO VERSION (Recommended) ==="
    echo "1. Install Go                               ./go/install_go.sh                   # Installs: Go programming language and toolchain"
    echo "2. Build Go tools                           ./go/build-all.sh                    # Compiles: All Go binaries (chrome-remote-desktop, install-chrome, etc.)"
    echo "3. Auto-detect Chrome Remote Desktop        ./go/chrome-remote-desktop           # Debian/Ubuntu: Chrome RD + XFCE + LightDM + Firefox + user account (auto-builds if needed)"
    echo "4. Install Google Chrome                    ./go/install-chrome                  # Installs: Google Chrome browser for your distribution (auto-builds if needed)"
    echo "5. Install Visual Studio Code               ./go/install-vscode                  # Installs: VS Code editor with official Microsoft repository (auto-builds if needed)"
    echo "6. Setup xRDP                               ./go/setup-xrdp                      #  UNIVERSAL: xRDP + XFCE + Firefox + VS Code + optimizations (works on ALL distros)"
    echo
    echo "=== SHELL VERSION (Legacy) ==="
    echo "7. Auto-detect Chrome Remote Desktop        ./shell/chrome_remote_desktop.sh     # Debian/Ubuntu: Chrome RD + XFCE + LightDM + Firefox + user account"
    echo "8. Install Google Chrome                    ./shell/chrome.sh                    # Installs: Google Chrome browser (supports all package managers)"
    echo "9. Install Visual Studio Code               ./shell/vscode.sh                    # Installs: VS Code editor (supports all package managers)"
    echo "10. Setup xRDP                              ./shell/setup_rdp.sh                 # UNIVERSAL: xRDP + XFCE + Firefox + VS Code + optimizations (works on ALL distros)"
    echo
    echo "=== MAINTENANCE TOOLS ==="
    echo "11. Update all tools                        ./update.sh                          # Updates: All installed tools + system packages + Go binaries"
    echo "12. Uninstall all tools                     ./uninstall_tools.sh                 # Removes: All tools (Chrome, VS Code, xRDP, XFCE, Firefox, LightDM)"
    echo "13. Uninstall Chrome Remote Desktop         ./uninstall_chrome_remote_desktop.sh # Removes: Chrome Remote Desktop + user account + config files"
    echo
    echo "0. Exit"
    echo
    printf "Enter your choice (1-13 or 0 to exit): "
}

# Function to run Go scripts with error handling
run_go_script() {
    local script="$1"
    local description="$2"

    # Check if Go binary exists, if not, try to build it
    if [ ! -f "$script" ]; then
        echo
        printf "${YELLOW}Go binary not found. Attempting to build...${NC}\n"

        # Try to build the Go binaries
        if [ -f "./go/build-all.sh" ]; then
            cd go
            if ./build-all.sh; then
                printf "${GREEN}✓ Go binaries built successfully!${NC}\n"
                cd ..
            else
                printf "${RED}✗ Failed to build Go binaries${NC}\n"
                read -p "Press Enter to continue..."
                return 1
            fi
        else
            printf "${RED}Error: build-all.sh not found!${NC}\n"
            read -p "Press Enter to continue..."
            return 1
        fi
    fi

    if [ -f "$script" ]; then
        echo
        printf "${BLUE}Running: $description${NC}\n"
        echo "----------------------------------------"
        if "$script"; then
            printf "\n${GREEN}✓ $description completed successfully!${NC}\n"
        else
            printf "\n${RED}✗ Error running $description${NC}\n"
            read -p "Press Enter to continue..."
        fi
    else
        printf "${RED}Error: Script $script not found after build attempt!${NC}\n"
        read -p "Press Enter to continue..."
    fi
}

# Function to run shell scripts with error handling
run_shell_script() {
    local script="$1"
    local description="$2"

    if [ -f "$script" ]; then
        echo
        printf "${BLUE}Running: $description${NC}\n"
        echo "----------------------------------------"
        if bash "$script"; then
            printf "\n${GREEN}✓ $description completed successfully!${NC}\n"
        else
            printf "\n${RED}✗ Error running $description${NC}\n"
            read -p "Press Enter to continue..."
        fi
    else
        printf "${RED}Error: Script $script not found!${NC}\n"
        read -p "Press Enter to continue..."
    fi
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        printf "${RED}Error: This script requires root privileges.${NC}\n"
        printf "${YELLOW}Please run with: sudo ./run.sh${NC}\n"
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Chrome Remote Desktop Setup - Command Line Options"
    echo "=================================================="
    echo
    echo "USAGE:"
    echo "  ./run.sh [option]          # Run specific tool"
    echo "  ./run.sh                   # Interactive menu"
    echo "  ./run.sh help              # Show this help"
    echo
    echo "INSTALLATION OPTIONS:"
    echo "  1, install-go              Install Go programming language"
    echo "  2, build-go                Build Go tools"
    echo "  3, chrome-remote-desktop   Auto-detect and install Chrome Remote Desktop (Go - auto-builds if needed)"
    echo "  4, install-chrome          Install Google Chrome Browser (Go - auto-builds if needed)"
    echo "  5, install-vscode          Install Visual Studio Code (Go - auto-builds if needed)"
    echo "  6, setup-xrdp              Setup xRDP (Go - auto-builds if needed)"
    echo "  7, chrome-remote-desktop-shell  Auto-detect Chrome Remote Desktop (Shell)"
    echo "  8, chrome-shell            Install Google Chrome (Shell)"
    echo "  9, vscode-shell            Install Visual Studio Code (Shell)"
    echo "  10, rdp-shell              Setup xRDP (Shell)"
    echo
    echo "MAINTENANCE OPTIONS:"
    echo "  11, update                 Update all tools and system"
    echo "  12, uninstall-tools        Uninstall all tools"
    echo "  13, uninstall              Uninstall Chrome Remote Desktop and user"
    echo
    echo "EXAMPLES:"
    echo "  sudo ./run.sh 1                    # Install Chrome Remote Desktop"
    echo "  sudo ./run.sh install-chrome       # Install Chrome (named option)"
    echo "  sudo ./run.sh update               # Update all tools"
    echo "  sudo ./run.sh uninstall-tools      # Remove all tools"
    echo
}

# Main program loop
main() {
    check_root

    # Check for command-line arguments
    if [[ $# -gt 0 ]]; then
        case "$1" in
            1|install-go)
                run_shell_script "./go/install_go.sh" "Install Go programming language"
                ;;
            2|build-go)
                run_go_script "./go/build-all.sh" "Build Go tools"
                ;;
            3|chrome-remote-desktop)
                run_go_script "./go/chrome-remote-desktop" "Auto-detect and install Chrome Remote Desktop (Go)"
                ;;
            4|install-chrome)
                run_go_script "./go/install-chrome" "Google Chrome Browser installation (Go)"
                ;;
            5|install-vscode)
                run_go_script "./go/install-vscode" "Visual Studio Code installation (Go)"
                ;;
            6|setup-xrdp)
                run_go_script "./go/setup-xrdp" "xRDP setup (Go)"
                ;;
            7|chrome-remote-desktop-shell)
                run_shell_script "./shell/chrome_remote_desktop.sh" "Auto-detect and install Chrome Remote Desktop (Shell)"
                ;;
            8|chrome-shell)
                run_shell_script "./shell/chrome.sh" "Google Chrome Browser installation (Shell)"
                ;;
            9|vscode-shell)
                run_shell_script "./shell/vscode.sh" "Visual Studio Code installation (Shell)"
                ;;
            10|rdp-shell)
                run_shell_script "./shell/setup_rdp.sh" "xRDP setup (Shell)"
                ;;
            11|update)
                run_shell_script "./update.sh" "Update all tools and system"
                ;;
            12|uninstall-tools)
                run_shell_script "./uninstall_tools.sh" "Uninstall all tools"
                ;;
            13|uninstall)
                run_shell_script "./uninstall_chrome_remote_desktop.sh" "Uninstall Chrome Remote Desktop and user"
                ;;
            help|--help|-h)
                show_help
                exit 0
                ;;
            *)
                printf "${RED}Invalid option: $1${NC}\n"
                show_help
                exit 1
                ;;
        esac
        exit 0
    fi

    # Interactive menu mode
    while true; do
        show_menu
        read -r choice

        case $choice in
            1)
                run_shell_script "./go/install_go.sh" "Install Go programming language"
                ;;
            2)
                run_go_script "./go/build-all.sh" "Build Go tools"
                ;;
            3)
                run_go_script "./go/chrome-remote-desktop" "Auto-detect and install Chrome Remote Desktop (Go)"
                ;;
            4)
                run_go_script "./go/install-chrome" "Google Chrome Browser installation (Go)"
                ;;
            5)
                run_go_script "./go/install-vscode" "Visual Studio Code installation (Go)"
                ;;
            6)
                run_go_script "./go/setup-xrdp" "xRDP setup (Go)"
                ;;
            7)
                run_shell_script "./shell/chrome_remote_desktop.sh" "Auto-detect and install Chrome Remote Desktop (Shell)"
                ;;
            8)
                run_shell_script "./shell/chrome.sh" "Google Chrome Browser installation (Shell)"
                ;;
            9)
                run_shell_script "./shell/vscode.sh" "Visual Studio Code installation (Shell)"
                ;;
            10)
                run_shell_script "./shell/setup_rdp.sh" "xRDP setup (Shell)"
                ;;
            11)
                run_shell_script "./update.sh" "Update all tools and system"
                ;;
            12)
                run_shell_script "./uninstall_tools.sh" "Uninstall all tools"
                ;;
            13)
                run_shell_script "./uninstall_chrome_remote_desktop.sh" "Uninstall Chrome Remote Desktop and user"
                ;;
            0)
                echo
                printf "${GREEN}Thank you for using Chrome Remote Desktop Setup!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option. Please choose 1-13 or 0.${NC}\n"
                read -p "Press Enter to continue..."
                ;;
        esac

        if [ "$choice" != "0" ]; then
            echo
            read -p "Press Enter to return to main menu..."
        fi
    done
}

# Run the main program
main