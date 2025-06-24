# SPARC IDE Build Guide

This guide provides detailed instructions for building SPARC IDE from source. SPARC IDE is built on top of VSCodium, which is a community-driven, freely-licensed binary distribution of Microsoft's VS Code.

## Prerequisites

### System Requirements

- **CPU**: 4+ cores recommended
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB+ free space
- **OS**: Linux (Ubuntu 20.04+), macOS 11+, or Windows 10+

### Required Software

1. **Git**: For cloning repositories
2. **Node.js 20.18**: Required by VSCodium (use nvm for easy management)
3. **Python 3.11+**: For native module compilation
4. **Yarn 1.22.19+**: Package manager
5. **jq**: JSON processor
6. **Build tools**: Platform-specific (see below)

### Platform-Specific Dependencies

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install build-essential gcc g++ make pkg-config libx11-dev libxkbfile-dev \
  libsecret-1-dev libkrb5-dev fakeroot rpm dpkg imagemagick jq python3 python3-pip
```

#### Linux (Fedora/RHEL)
```bash
sudo dnf install make gcc gcc-c++ pkg-config libX11-devel libxkbfile-devel \
  libsecret-devel krb5-devel rpm-build ImageMagick jq python3 python3-pip
```

#### macOS
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install additional dependencies via Homebrew
brew install jq imagemagick python@3.11
```

#### Windows
- Visual Studio Build Tools with "Desktop development with C++"
- Git Bash or WSL2 for running shell scripts
- Python 3.11+ from python.org

## Build Process Overview

SPARC IDE uses a multi-stage build process:

1. **Setup**: Clone VSCodium and prepare the build environment
2. **Branding**: Apply SPARC IDE customizations
3. **Extensions**: Add Roo Code and other extensions
4. **Build**: Compile the application
5. **Package**: Create platform-specific installers

## Step-by-Step Build Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/sparc-ide/sparc-ide.git
cd sparc-ide
```

### 2. Run Setup Script

The setup script prepares the entire build environment:

```bash
chmod +x scripts/setup-sparc-ide.sh
./scripts/setup-sparc-ide.sh
```

This script will:
- Check prerequisites
- Clone the VSCodium repository
- Apply SPARC IDE branding
- Download/create the Roo Code extension
- Configure the UI
- Set up the MCP server
- Create workflow directories

**Note**: If you encounter the error "Existing directory is not a git repository", remove the `vscodium` directory and run the setup again:
```bash
rm -rf vscodium
./scripts/setup-sparc-ide.sh
```

### 3. Build SPARC IDE

You have three options for building:

#### Option 1: Development Build (Recommended for first-time builders)

```bash
cd vscodium
./dev/build.sh
```

This is the simplest method and handles most of the complexity automatically.

#### Option 2: Production Build

```bash
cd vscodium

# Set environment variables
export SHOULD_BUILD="yes"
export SHOULD_BUILD_REH="no"
export CI_BUILD="no"
export OS_NAME="linux"  # or "osx" for macOS, "windows" for Windows
export VSCODE_ARCH="x64"  # or "arm64" for ARM processors
export VSCODE_QUALITY="stable"

# Run build
./get_repo.sh
./build.sh
```

#### Option 3: SPARC IDE Build Script

```bash
# From the sparc-ide directory
./scripts/build-sparc-ide.sh --platform linux
```

### 4. Build Output

After a successful build, you'll find:

- **Application**: Located in `vscodium/VSCode-linux-x64/` (or similar for other platforms)
- **Packages**: Created by VSCodium's build process, typically in the `vscodium/` directory

## Common Issues and Solutions

### Node.js Version Mismatch

VSCodium requires Node.js 20.18. Use nvm to manage versions:

```bash
nvm install 20.18
nvm use 20.18
```

### Missing Kerberos Headers

If you see errors about `gssapi/gssapi.h`:

```bash
# Ubuntu/Debian
sudo apt-get install libkrb5-dev

# Fedora/RHEL
sudo dnf install krb5-devel
```

### Build Failures

If the build fails:

1. Check Node.js version: `node --version` (should be 20.18.x)
2. Ensure all dependencies are installed
3. Clear npm cache: `npm cache clean --force`
4. Remove node_modules and try again:
   ```bash
   cd vscodium/vscode
   rm -rf node_modules
   cd ../..
   ```

### Permission Issues

If you encounter permission errors:

```bash
chmod +x scripts/*.sh
chmod +x vscodium/*.sh
chmod +x vscodium/dev/*.sh
```

## Build Times

Expect the following build times:

- **First build**: 45-90 minutes (downloads all dependencies)
- **Subsequent builds**: 15-30 minutes
- **Incremental builds**: 5-10 minutes

Build times vary based on:
- CPU performance
- Available RAM
- Network speed (for downloading dependencies)
- SSD vs HDD

## Verifying the Build

After building, verify your installation:

1. **Run the application**:
   ```bash
   cd vscodium/VSCode-linux-x64
   ./codium
   ```

2. **Check version**:
   - Open SPARC IDE
   - Go to Help > About
   - Verify it shows "SPARC IDE" branding

3. **Test extensions**:
   - Open the Extensions view (Ctrl+Shift+X)
   - Verify Roo Code extension is installed

4. **Test MCP server**:
   ```bash
   cd src/mcp
   ./start-mcp-server.sh
   ```
   Then navigate to http://localhost:3001

## Creating Distribution Packages

VSCodium's build process automatically creates distribution packages. Look for:

- **Linux**: `.deb`, `.rpm`, `.tar.gz` files
- **Windows**: `.exe` installer, `.zip` archive
- **macOS**: `.dmg` disk image, `.zip` archive

These are typically found in the `vscodium/` directory after building.

## Development Workflow

For development, use the following workflow:

1. Make changes to SPARC IDE customizations
2. Run the branding script to apply changes:
   ```bash
   ./scripts/apply-branding.sh
   ```
3. Build using the dev script:
   ```bash
   cd vscodium
   ./dev/build.sh -o  # -o skips the full rebuild
   ```

## Security Considerations

The build process includes security checks:

- Signature verification for downloaded components
- Scanning for hardcoded credentials
- Permission verification
- Dependency vulnerability checks

Always review security warnings before proceeding with a build.

## Getting Help

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review the [VSCodium build documentation](https://github.com/VSCodium/vscodium/blob/master/docs/howto-build.md)
3. Check [GitHub Issues](https://github.com/sparc-ide/sparc-ide/issues)
4. Join the [SPARC IDE Discord](https://discord.gg/sparc-ide)

## Next Steps

After successfully building SPARC IDE:

1. Read the [User Guide](user-guide.md) to learn about SPARC IDE features
2. Configure API keys for AI features
3. Initialize a SPARC workflow in your project
4. Start building with AI assistance!