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

# Function to build Go binary if needed
ensure_go_binary() {
    if [ ! -f "go/chrome-remote-desktop-installer" ]; then
        printf "${BLUE}Building Go binary...${NC}\n"
        cd go
        if ! go build -o chrome-remote-desktop-installer .; then
            printf "${RED}Failed to build Go binary. Make sure Go is installed.${NC}\n"
            cd ..
            return 1
        fi
        cd ..
        printf "${GREEN}✓ Go binary built successfully!${NC}\n"
    fi
    return 0
}

# Function to display version selection menu
show_version_menu() {
    clear
    echo
    draw_box "Server Setup Tools - Version Selection"
    echo
    printf "${WHITE}Choose implementation version:${NC}\n\n"
    
    printf "${GREEN}1)${NC} ${WHITE}Go Version (Recommended)${NC}\n"
    printf "   ${CYAN}• Modern, fast, and feature-rich${NC}\n"
    printf "   ${CYAN}• Single binary with no dependencies${NC}\n"
    printf "   ${CYAN}• Better error handling and UX${NC}\n"
    printf "   ${CYAN}• Comprehensive development tools${NC}\n\n"
    
    printf "${YELLOW}2)${NC} ${WHITE}Shell Script Version (Legacy)${NC}\n"
    printf "   ${CYAN}• Original Chrome Remote Desktop installer${NC}\n"
    printf "   ${CYAN}• Simple and lightweight${NC}\n"
    printf "   ${CYAN}• Compatible with minimal systems${NC}\n\n"
    
    printf "${BLUE}3)${NC} ${WHITE}Direct Commands${NC}\n"
    printf "   ${CYAN}• Run specific functionality directly${NC}\n\n"
    
    printf "${RED}0)${NC} ${WHITE}Exit${NC}\n"
    echo
    printf "${YELLOW}Enter your choice [1-3,0]: ${NC}"
}

# Function to show direct command options
show_direct_commands() {
    clear
    echo
    draw_box "Direct Command Options"
    echo
    printf "${WHITE}Available direct commands:${NC}\n\n"
    
    printf "${GREEN}Go Version Commands:${NC}\n"
    printf "  ${CYAN}sudo go/chrome-remote-desktop-installer${NC}                    # Interactive menu\n"
    printf "  ${CYAN}sudo go/chrome-remote-desktop-installer --auto${NC}             # Auto Chrome RDP\n"
    printf "  ${CYAN}sudo go/chrome-remote-desktop-installer --chrome${NC}           # Install Chrome\n"
    printf "  ${CYAN}sudo go/chrome-remote-desktop-installer --vscode${NC}           # Install VS Code\n"
    printf "  ${CYAN}sudo go/chrome-remote-desktop-installer --help${NC}             # Show help\n\n"
    
    printf "${YELLOW}Shell Version Commands:${NC}\n"
    printf "  ${CYAN}sudo shell/run.sh${NC}                                          # Interactive menu\n"
    printf "  ${CYAN}sudo shell/chrome_remote_desktop.sh${NC}                        # Auto-detect install\n"
    printf "  ${CYAN}sudo shell/apt.sh${NC}                                          # Debian/Ubuntu\n"
    printf "  ${CYAN}sudo shell/dnf.sh${NC}                                          # Red Hat/Fedora\n"
    printf "  ${CYAN}sudo shell/pacman.sh${NC}                                       # Arch Linux\n"
    printf "  ${CYAN}sudo shell/zypper.sh${NC}                                       # openSUSE\n"
    printf "  ${CYAN}sudo shell/chrome.sh${NC}                                       # Install Chrome\n"
    printf "  ${CYAN}sudo shell/vscode.sh${NC}                                       # Install VS Code\n\n"
    
    printf "${PURPLE}Other:${NC}\n"
    printf "  ${CYAN}sudo xrdp/setup_rdp.sh${NC}                                     # Setup xRDP\n\n"
    
    read -p "Press Enter to return to main menu..."
}

# Function to run Go version
run_go_version() {
    if ! ensure_go_binary; then
        printf "${RED}Cannot run Go version. Build failed.${NC}\n"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    printf "${BLUE}Starting Go version...${NC}\n"
    echo "========================================"
    ./go/chrome-remote-desktop-installer
}

# Function to run Shell version
run_shell_version() {
    if [ ! -f "shell/run.sh" ]; then
        printf "${RED}Shell version not found at shell/run.sh${NC}\n"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    printf "${BLUE}Starting Shell version...${NC}\n"
    echo "========================================"
    bash shell/run.sh
}

# Main program loop
main() {
    check_root
    
    while true; do
        show_version_menu
        read -r choice
        
        case $choice in
            1)
                run_go_version
                ;;
            2)
                run_shell_version
                ;;
            3)
                show_direct_commands
                ;;
            0)
                echo
                printf "${GREEN}Thank you for using Server Setup Tools!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option. Please choose 1-3 or 0.${NC}\n"
                read -p "Press Enter to continue..."
                ;;
        esac
        
        if [ "$choice" != "0" ] && [ "$choice" != "3" ]; then
            echo
            read -p "Press Enter to return to version selection..."
        fi
    done
}

# Handle direct command line arguments
if [ $# -gt 0 ]; then
    case $1 in
        "go")
            check_root
            run_go_version
            exit $?
            ;;
        "shell")
            check_root
            run_shell_version
            exit $?
            ;;
        "build")
            printf "${BLUE}Building Go binary...${NC}\n"
            cd go && go build -o chrome-remote-desktop-installer .
            exit $?
            ;;
        "--help"|"-h")
            echo "Server Setup Tools"
            echo ""
            echo "Usage: $0 [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  go        Run Go version directly"
            echo "  shell     Run Shell version directly"
            echo "  build     Build Go binary"
            echo "  --help    Show this help"
            echo ""
            echo "Without arguments, shows interactive version selection menu"
            exit 0
            ;;
        *)
            printf "${RED}Unknown command: $1${NC}\n"
            printf "Run '$0 --help' for usage information\n"
            exit 1
            ;;
    esac
fi

# Run the main program
main