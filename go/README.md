# Chrome Remote Desktop Installer (Go Version)

A Go-based automated installer for Chrome Remote Desktop that works across different Linux distributions.

## Features

- **Cross-platform**: Single binary that works on all supported Linux distributions
- **Interactive Menu**: Easy-to-use colored menu interface
- **Auto-detection**: Automatically detects distribution and package manager
- **Secure Configuration**: Password masking and secure config file handling
- **Multiple Installation Options**: Chrome Remote Desktop, Google Chrome, VS Code
- **Better Error Handling**: Comprehensive error reporting and recovery

## Supported Distributions

- Debian/Ubuntu based systems (apt)
- Red Hat/Fedora based systems (dnf) 
- Arch Linux based systems (pacman)
- openSUSE based systems (zypper)

## Installation

### Build from Source

```bash
cd go/
go mod tidy
go build -o chrome-remote-desktop-installer .
sudo ./chrome-remote-desktop-installer
```

### Cross-compilation

```bash
# For different architectures
GOOS=linux GOARCH=amd64 go build -o chrome-remote-desktop-installer-amd64 .
GOOS=linux GOARCH=arm64 go build -o chrome-remote-desktop-installer-arm64 .
```

## Usage

### Interactive Menu (Default)

```bash
sudo ./chrome-remote-desktop-installer
```

### Command Line Options

```bash
# Auto-install Chrome Remote Desktop
sudo ./chrome-remote-desktop-installer --auto

# Install Google Chrome only
sudo ./chrome-remote-desktop-installer --chrome

# Install VS Code only
sudo ./chrome-remote-desktop-installer --vscode

# Use custom config file
sudo ./chrome-remote-desktop-installer --config /path/to/config.json
```

## Configuration

The application creates a `config.json` file to store user credentials:

```json
{
  "user": {
    "username": "your-username",
    "password": "your-password"
  }
}
```

## What Gets Installed

- Chrome Remote Desktop
- XFCE Desktop Environment
- LightDM Display Manager
- Firefox Web Browser
- Required dependencies

## Advantages over Shell Script Version

1. **Single Binary**: No dependencies on shell, python3, or other tools
2. **Better Error Handling**: Comprehensive error reporting with stack traces
3. **Secure Input**: Proper password masking and validation
4. **Cross-platform**: Consistent behavior across all distributions
5. **Concurrent Operations**: Faster installations with parallel processing
6. **Type Safety**: Compile-time error checking
7. **Better UX**: Colored output and professional CLI interface
8. **Maintainable**: Structured code with proper separation of concerns

## Architecture

```
go/
├── cmd/                    # CLI commands
│   └── root.go
├── internal/
│   ├── config/            # Configuration handling
│   ├── installer/         # Installation logic
│   ├── platform/          # OS detection
│   └── ui/                # User interface
├── pkg/
│   ├── downloader/        # File downloading
│   └── system/            # System operations
└── main.go
```

## Contributing

Feel free to submit issues and enhancement requests!