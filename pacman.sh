#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update system
echo "Updating system packages..."
pacman -Syu --noconfirm

# Install yay AUR helper if not installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper..."
    pacman -S --needed --noconfirm git base-devel
    temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir"
    cd "$temp_dir"
    chown -R nobody:nobody ./
    su nobody -s /bin/bash -c "makepkg -si --noconfirm"
    cd -
    rm -rf "$temp_dir"
fi

# Install Chrome Remote Desktop from AUR
echo "Installing Chrome Remote Desktop..."
su nobody -s /bin/bash -c "yay -S --noconfirm chrome-remote-desktop"

# Install XFCE Desktop Environment
echo "Installing XFCE desktop environment..."
pacman -S --noconfirm xfce4 xfce4-goodies

# Install display manager
echo "Installing LightDM display manager..."
pacman -S --noconfirm lightdm lightdm-gtk-greeter
systemctl enable lightdm

# Install Firefox browser
echo "Installing Firefox..."
pacman -S --noconfirm firefox

# Configure Chrome Remote Desktop to use XFCE
echo "Configuring Chrome Remote Desktop to use XFCE..."
mkdir -p /etc/chrome-remote-desktop-session
echo "exec /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session

# Create new user
echo "Creating new user for remote access..."
read -p "Enter username: " USERNAME
while [[ -z "$USERNAME" ]]; do
    echo "Username cannot be empty"
    read -p "Enter username: " USERNAME
done

read -s -p "Enter password: " PASSWORD
echo
read -s -p "Confirm password: " PASSWORD2
echo

while [[ "$PASSWORD" != "$PASSWORD2" ]]; do
    echo "Passwords do not match!"
    read -s -p "Enter password: " PASSWORD
    echo
    read -s -p "Confirm password: " PASSWORD2
    echo
done

# Create user and set password
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Add user to necessary groups
usermod -aG wheel "$USERNAME"
usermod -aG chrome-remote-desktop "$USERNAME"

# Enable sudo for wheel group
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

echo "Installation completed!"
echo "Please follow these steps to complete setup:"
echo "1. Install Chrome Remote Desktop extension in your Chrome browser"
echo "2. Go to https://remotedesktop.google.com/access"
echo "3. Click on 'Set up remote access'"
echo "4. Follow the prompts to set up your computer for remote access"
echo "5. When asked, use your newly created username and password"

# Switch to new user
echo "Switching to new user..."
su - "$USERNAME"