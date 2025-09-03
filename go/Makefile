BINARY_NAME=chrome-remote-desktop-installer
BUILD_DIR=build

.PHONY: build clean install cross-compile test

# Default build
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY_NAME) .

# Install dependencies
deps:
	go mod tidy
	go mod download

# Cross-compile for different architectures
cross-compile:
	@echo "Cross-compiling for multiple architectures..."
	@mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 .
	GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY_NAME)-linux-arm64 .
	GOOS=linux GOARCH=386 go build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY_NAME)-linux-386 .

# Install to system
install: build
	@echo "Installing $(BINARY_NAME) to /usr/local/bin..."
	sudo cp $(BUILD_DIR)/$(BINARY_NAME) /usr/local/bin/
	sudo chmod +x /usr/local/bin/$(BINARY_NAME)

# Clean build artifacts
clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)

# Run tests
test:
	go test ./...

# Run with development flags
dev: build
	sudo ./$(BUILD_DIR)/$(BINARY_NAME)

# Show help
help:
	@echo "Available targets:"
	@echo "  build        - Build the application"
	@echo "  deps         - Install dependencies"
	@echo "  cross-compile - Build for multiple architectures"
	@echo "  install      - Install to system (/usr/local/bin)"
	@echo "  clean        - Clean build artifacts"
	@echo "  test         - Run tests"
	@echo "  dev          - Build and run in development mode"
	@echo "  help         - Show this help message"