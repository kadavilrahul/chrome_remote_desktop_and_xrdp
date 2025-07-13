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
    draw_box "Chrome Remote Desktop Setup Menu"
    echo
    printf "${WHITE}Choose an option:${NC}\n\n"
    
    printf "${GREEN}1)${NC} ${WHITE}Auto-detect and install Chrome Remote Desktop${NC}\n"
    printf "${GREEN}2)${NC} ${WHITE}Install Google Chrome Browser${NC}\n"
    printf "${GREEN}3)${NC} ${WHITE}Install Visual Studio Code${NC}\n"
    printf "${GREEN}4)${NC} ${WHITE}Setup xRDP${NC}\n"
    printf "${RED}5)${NC} ${WHITE}Exit${NC}\n"
    echo
    printf "${YELLOW}Enter your choice [1-5]: ${NC}"
}

# Function to run scripts with error handling
run_script() {
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

# Main program loop
main() {
    check_root
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                run_script "./chrome_remote_desktop.sh" "Auto-detect and install Chrome Remote Desktop"
                ;;
            2)
                run_script "./chrome.sh" "Google Chrome Browser installation"
                ;;
            3)
                run_script "./vscode.sh" "Visual Studio Code installation"
                ;;
            4)
                run_script "./xrdp/setup_rdp.sh" "xRDP setup"
                ;;
            5)
                echo
                printf "${GREEN}Thank you for using Chrome Remote Desktop Setup!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option. Please choose 1-5.${NC}\n"
                read -p "Press Enter to continue..."
                ;;
        esac
        
        if [ "$choice" != "5" ]; then
            echo
            read -p "Press Enter to return to main menu..."
        fi
    done
}

# Run the main program
main