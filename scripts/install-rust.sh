#!/bin/bash
# SPARC IDE - Rust Installation Helper Script
# This script helps install Rust toolchain required for building VSCode CLI

set -e

# Print colored output
print_info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1"
}

# Check if Rust is already installed
check_rust_installed() {
    if command -v rustup &> /dev/null && command -v cargo &> /dev/null; then
        print_info "Rust is already installed:"
        print_info "  rustc version: $(rustc --version)"
        print_info "  cargo version: $(cargo --version)"
        return 0
    fi
    return 1
}

# Install Rust
install_rust() {
    print_info "Installing Rust toolchain..."
    
    # Download and run the official Rust installer
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Source the cargo environment
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    
    print_success "Rust installed successfully!"
}

# Add cargo to PATH for current session
setup_path() {
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
        print_info "Cargo environment loaded for current session"
    fi
}

# Main function
main() {
    print_info "SPARC IDE Rust Installation Helper"
    print_info "===================================="
    
    if check_rust_installed; then
        print_success "Rust is already installed and ready to use!"
        exit 0
    fi
    
    print_info "Rust is not installed. This script will install Rust using the official installer."
    print_info "This will install rustup, cargo, and the stable Rust toolchain."
    
    # Prompt for confirmation
    read -p "Do you want to proceed with Rust installation? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_rust
        setup_path
        
        if check_rust_installed; then
            print_success "Rust installation completed successfully!"
            print_info ""
            print_info "IMPORTANT: To use Rust in new terminal sessions, you need to either:"
            print_info "  1. Restart your terminal, OR"
            print_info "  2. Run: source \$HOME/.cargo/env"
            print_info ""
            print_info "After that, you can continue with building SPARC IDE."
        else
            print_error "Rust installation may have failed. Please check the output above."
            exit 1
        fi
    else
        print_info "Rust installation cancelled."
        print_info "You can install Rust manually by running:"
        print_info "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        exit 0
    fi
}

# Run main function
main