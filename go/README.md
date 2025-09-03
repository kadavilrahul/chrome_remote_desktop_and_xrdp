# Server Setup Go - System Configuration Tool

A comprehensive Go-based system configuration tool that provides an all-in-one solution for setting up development environments on Linux servers.

## Features

- **Development Tools**: GitHub CLI, OpenCode Editor, Gemini CLI, CLOC, Node.js, Zoxide, Google Cloud CLI
- **System Configuration**: Timezone setup, command aliases, and system optimizations
- **Repository Management**: Clone favorite repositories, browse and clone custom repos
- **SSH Helpers**: Generate SSH commands for different platforms and scenarios
- **Cross-platform**: Single binary that works on all supported Linux distributions
- **Interactive Menu**: Easy-to-use colored menu interface with CLI command equivalents
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

The menu displays options in the format:
```
1.  Install GitHub CLI             ./run.sh gh-install        # Required for repo management
2.  Install OpenCode Editor        ./run.sh opencode-install  # AI-powered code assistant
...
```

### Command Line Options

```bash
# Individual installations (legacy Chrome Remote Desktop support)
sudo ./chrome-remote-desktop-installer --auto
sudo ./chrome-remote-desktop-installer --chrome
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

## Available Tools & Features

### Development Tools Installation
- GitHub CLI - Repository management
- OpenCode Editor - AI-powered code assistant  
- Gemini CLI - Google Gemini AI CLI
- CLOC - Count lines of code
- Node.js & npm - JavaScript runtime
- Zoxide - Smart cd replacement
- Google Cloud CLI - GCP management tool

### System Configuration
- Timezone setup (Asia/Kolkata)
- Command aliases and shortcuts
- System optimizations

### Repository Management
- Clone favorite repositories
- Interactive repository browser
- List and manage cloned repos

### SSH Connection Helpers
- Generate SSH commands for Windows PowerShell
- Generate SSH commands for Linux/Mac Terminal
- Non-root to root access helpers

## Advantages over Shell Script Version

1. **Single Binary**: No dependencies on shell, python3, or other tools
2. **Better Error Handling**: Comprehensive error reporting with stack traces
3. **Structured Menu**: Clear categorization with CLI command equivalents
4. **Cross-platform**: Consistent behavior across all distributions
5. **Type Safety**: Compile-time error checking
6. **Better UX**: Colored output and professional CLI interface
7. **Maintainable**: Structured code with proper separation of concerns

## Architecture

```
go/
├── cmd/                    # CLI commands
│   └── root.go
├── internal/
│   ├── config/            # Configuration handling  
│   ├── installer/         # Installation modules
│   │   ├── chrome_remote_desktop.go  # Legacy CRD installer
│   │   ├── dev_tools.go              # Development tools
│   │   ├── system_config.go          # System configuration
│   │   ├── repo_manager.go           # Repository management
│   │   ├── ssh_helper.go             # SSH helpers
│   │   └── tools.go                  # Additional tools
│   ├── platform/          # OS detection
│   └── ui/                # User interface
├── pkg/
│   ├── downloader/        # File downloading
│   └── system/            # System operations
└── main.go
```

## Project Structure

- **shell/**: Original shell script version
- **go/**: Go implementation with enhanced features
- **xrdp/**: XRDP setup scripts

## Contributing

Feel free to submit issues and enhancement requests!