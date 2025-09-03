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

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        printf "${RED}Error: This script requires root privileges.${NC}\n"
        printf "${YELLOW}Please run with: sudo ./run.sh${NC}\n"
        exit 1
    fi
}

# Function to build Go binaries if needed
ensure_go_binaries() {
    if [ ! -f "go-tools/chrome-remote-desktop" ]; then
        printf "${BLUE}Building Go binaries...${NC}\n"
        cd go-tools
        if ! bash build-all.sh; then
            printf "${RED}Failed to build Go binaries. Make sure Go is installed.${NC}\n"
            cd ..
            return 1
        fi
        cd ..
        printf "${GREEN}✓ Go binaries built successfully!${NC}\n"
    fi
    return 0
}

# Function to display main menu
show_menu() {
    clear
    echo
    draw_box "Server Setup Tools - Main Menu"
    echo
    printf "${WHITE}Choose an option:${NC}\n\n"
    
    printf "${GREEN}=== Installation Tools ===${NC}\n"
    printf "${CYAN}1.${NC}  Auto-detect and install Chrome Remote Desktop    ${YELLOW}./run.sh chrome-remote-desktop${NC}    ${GREEN}# Multi-distro installer${NC}\n"
    printf "${CYAN}2.${NC}  Install Google Chrome Browser                     ${YELLOW}./run.sh install-chrome${NC}          ${GREEN}# Web browser${NC}\n"
    printf "${CYAN}3.${NC}  Install Visual Studio Code                        ${YELLOW}./run.sh install-vscode${NC}          ${GREEN}# Code editor${NC}\n"
    printf "${CYAN}4.${NC}  Setup xRDP for Microsoft RDP                      ${YELLOW}./run.sh setup-xrdp${NC}              ${GREEN}# Remote desktop protocol${NC}\n"
    echo
    printf "${GREEN}=== Utilities ===${NC}\n"
    printf "${CYAN}5.${NC}  Build Go Tools                                     ${YELLOW}./run.sh build${NC}                   ${GREEN}# Compile binaries${NC}\n"
    printf "${CYAN}6.${NC}  Show All Commands                                  ${YELLOW}./run.sh help${NC}                    ${GREEN}# Command reference${NC}\n"
    echo
    printf "${RED}0.${NC}  Exit\n"
    echo
    printf "${YELLOW}Enter your choice [1-6,0]: ${NC}"
}

# Function to run command with error handling
run_command() {
    local cmd="$1"
    local description="$2"
    
    printf "${BLUE}Running: $description${NC}\n"
    echo "========================================"
    
    if eval "$cmd"; then
        printf "\n${GREEN}✓ $description completed successfully!${NC}\n"
    else
        printf "\n${RED}✗ Error running $description${NC}\n"
        read -p "Press Enter to continue..."
    fi
}

# Function to show all commands
show_all_commands() {
    clear
    echo
    draw_box "All Available Commands"
    echo
    printf "${WHITE}Direct CLI Commands:${NC}\n\n"
    
    printf "${GREEN}Chrome Remote Desktop Tools:${NC}\n"
    printf "  ${CYAN}sudo ./run.sh chrome-remote-desktop${NC}    # Auto-detect and install Chrome Remote Desktop\n"
    printf "  ${CYAN}sudo ./run.sh install-chrome${NC}           # Install Google Chrome Browser\n"
    printf "  ${CYAN}sudo ./run.sh install-vscode${NC}           # Install Visual Studio Code\n"
    printf "  ${CYAN}sudo ./run.sh setup-xrdp${NC}               # Setup xRDP for Microsoft RDP\n\n"
    
    printf "${YELLOW}Direct Shell Script Commands (Advanced):${NC}\n"
    printf "  ${CYAN}sudo bash shell/chrome_remote_desktop.sh${NC} # Auto-detect installer\n"
    printf "  ${CYAN}sudo bash shell/apt.sh${NC}                  # Debian/Ubuntu installer\n"
    printf "  ${CYAN}sudo bash shell/dnf.sh${NC}                  # Red Hat/Fedora installer\n"
    printf "  ${CYAN}sudo bash shell/pacman.sh${NC}               # Arch Linux installer\n"
    printf "  ${CYAN}sudo bash shell/zypper.sh${NC}               # openSUSE installer\n"
    printf "  ${CYAN}sudo bash shell/chrome.sh${NC}               # Install Google Chrome\n"
    printf "  ${CYAN}sudo bash shell/vscode.sh${NC}               # Install Visual Studio Code\n"
    printf "  ${CYAN}sudo bash shell/setup_rdp.sh${NC}            # Setup xRDP\n\n"
    
    printf "${BLUE}Build & Utility:${NC}\n"
    printf "  ${CYAN}./run.sh build${NC}                          # Build Go tools\n"
    printf "  ${CYAN}./run.sh help${NC}                           # Show this help\n\n"
    
    read -p "Press Enter to return to main menu..."
}

# Main program loop
main() {
    check_root
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                ensure_go_binaries
                run_command "./go-tools/chrome-remote-desktop" "Chrome Remote Desktop Installation"
                ;;
            2)
                ensure_go_binaries
                run_command "./go-tools/install-chrome" "Google Chrome Installation"
                ;;
            3)
                ensure_go_binaries
                run_command "./go-tools/install-vscode" "Visual Studio Code Installation"
                ;;
            4)
                ensure_go_binaries
                run_command "./go-tools/setup-xrdp" "xRDP Setup"
                ;;
            5)
                run_command "cd go-tools && bash build-all.sh" "Building Go Tools"
                ;;
            6)
                show_all_commands
                ;;
            0)
                echo
                printf "${GREEN}Thank you for using Server Setup Tools!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option. Please choose 1-6 or 0.${NC}\n"
                read -p "Press Enter to continue..."
                ;;
        esac
        
        if [ "$choice" != "0" ] && [ "$choice" != "6" ]; then
            echo
            read -p "Press Enter to return to main menu..."
        fi
    done
}

# Handle direct command line arguments
if [ $# -gt 0 ]; then
    case $1 in
        "chrome-remote-desktop")
            check_root
            ensure_go_binaries
            ./go-tools/chrome-remote-desktop
            exit $?
            ;;
        "install-chrome")
            check_root
            ensure_go_binaries
            ./go-tools/install-chrome
            exit $?
            ;;
        "install-vscode")
            check_root
            ensure_go_binaries
            ./go-tools/install-vscode
            exit $?
            ;;
        "setup-xrdp")
            check_root
            ensure_go_binaries
            ./go-tools/setup-xrdp
            exit $?
            ;;

        "build")
            printf "${BLUE}Building Go tools...${NC}\n"
            cd go-tools && bash build-all.sh
            exit $?
            ;;
        "help"|"--help"|"-h")
            echo "Server Setup Tools"
            echo ""
            echo "Usage: $0 [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  chrome-remote-desktop    Auto-detect and install Chrome Remote Desktop"
            echo "  install-chrome           Install Google Chrome Browser"
            echo "  install-vscode           Install Visual Studio Code"
            echo "  setup-xrdp               Setup xRDP for Microsoft RDP"
            echo "  build                    Build Go tools"
            echo "  help                     Show all available commands"
            echo ""
            echo "Without arguments, shows interactive main menu"
            exit 0
            ;;
        *)
            printf "${RED}Unknown command: $1${NC}\n"
            printf "Run '$0 help' for usage information\n"
            exit 1
            ;;
    esac
fi

# Run the main program
main