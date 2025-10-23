#!/bin/bash
# install_kstars.sh - A script to install KStars and all its dependencies
# This script automates the installation of KStars and INDI on macOS

set -e  # Exit immediately if a command exits with a non-zero status

echo "KStars Installer for macOS"
echo "=========================="
echo

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display status messages
status() {
    echo -e "${BLUE}==>${NC} $1"
}

# Function to display success messages
success() {
    echo -e "${GREEN}==>${NC} $1"
}

# Function to display error messages
error() {
    echo -e "${RED}==>${NC} $1"
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    error "Homebrew is not installed. Please install it first."
    echo "Visit https://brew.sh for instructions."
    exit 1
fi

# Create necessary directories
ASTRO_ROOT=~/AstroRoot
INDI_DIR=${ASTRO_ROOT}/indi-stuff
KSTARS_DIR=${ASTRO_ROOT}/kstars-stuff
GSC_DIR=${ASTRO_ROOT}/gsc

status "Setting up directories..."
mkdir -p ${INDI_DIR}
mkdir -p ${KSTARS_DIR}
mkdir -p ${GSC_DIR}
success "Directories created"

# Tap the custom KStars repository
status "Tapping custom KStars repository..."
brew tap jrrk2/kstars https://github.com/jrrk2/homebrew-kstars
success "Tap added"

# Install QT (with options)
status "Installing Qt and dependencies (this may take a while)..."
brew install qt
brew link --force gettext
success "Qt installed"

# Install KDE Frameworks dependencies
status "Installing KDE Frameworks dependencies..."
brew tap KDE-mac/kde
brew install KDE-mac/kde/kf5-kwallet
brew install KDE-mac/kde/kf5-kcoreaddons
brew link --overwrite kf5-kcoreaddons
brew install KDE-mac/kde/kf5-kcrash
brew install aspell  # For kf5 sonnet
brew install KDE-mac/kde/kf5-knotifyconfig
brew install KDE-mac/kde/kf5-knotifications
brew install KDE-mac/kde/kf5-kplotting
brew install KDE-mac/kde/kf5-kxmlgui
brew install KDE-mac/kde/kf5-kdoctools
brew install KDE-mac/kde/kf5-knewstuff
brew install KDE-mac/kde/kf5-kded
success "KDE Frameworks dependencies installed"

# Install INDI
status "Installing INDI libraries..."
brew install indi-lib
success "INDI libraries installed"

# Install KStars
status "Installing KStars..."
brew install jrrk2/kstars/kstars
success "KStars installed"

echo
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}KStars installation completed successfully!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo
echo "You can now launch KStars from your Applications folder."
echo "If you encounter any issues, please report them at:"
echo "https://github.com/jrrk2/homebrew-kstars/issues"
