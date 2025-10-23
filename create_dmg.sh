#!/bin/bash
# create_dmg.sh - A script to create a custom DMG of KStars
# This script creates a redistributable DMG of KStars

set -e  # Exit immediately if a command exits with a non-zero status

echo "KStars DMG Creator for macOS"
echo "==========================="
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

# Check if KStars is installed
KSTARS_APP="/Applications/KDE/kstars.app"
if [ ! -d "$KSTARS_APP" ]; then
    error "KStars is not installed at $KSTARS_APP"
    echo "Please install KStars first."
    exit 1
fi

# Create output directory
DMG_DIR=~/Desktop
mkdir -p "$DMG_DIR"

# Get KStars version
if [ -f "$KSTARS_APP/Contents/Info.plist" ]; then
    KSTARS_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$KSTARS_APP/Contents/Info.plist")
else
    # Default version if we can't detect it
    KSTARS_VERSION="3.7.9"
fi

status "Creating DMG for KStars $KSTARS_VERSION..."

# Create temporary directory for DMG contents
TMP_DIR=$(mktemp -d)
status "Creating temporary directory at $TMP_DIR"

# Copy KStars.app to temporary directory
cp -R "$KSTARS_APP" "$TMP_DIR/"
success "Copied KStars.app to temporary directory"

# Create symbolic link to Applications folder
ln -s /Applications "$TMP_DIR/Applications"
success "Created symbolic link to Applications folder"

# Add README file
cat > "$TMP_DIR/README.txt" << EOF
KStars $KSTARS_VERSION

KStars is a desktop planetarium for KDE. It provides an accurate graphical
simulation of the night sky, from any location on Earth, at any date and time.
The display includes up to 100 million stars, 13,000 deep-sky objects, all 8
planets, the Sun and Moon, and thousands of comets, asteroids, supernovae, and
satellites.

To install KStars, simply drag the KStars icon to the Applications folder.

For more information, visit:
https://edu.kde.org/kstars/
EOF
success "Created README.txt file"

# Create DMG
DMG_FILE="$DMG_DIR/KStars-$KSTARS_VERSION.dmg"
status "Creating DMG at $DMG_FILE"

hdiutil create -volname "KStars-$KSTARS_VERSION" \
              -srcfolder "$TMP_DIR" \
              -ov -format UDZO \
              "$DMG_FILE"

# Create checksum files
cd "$DMG_DIR"
md5 "KStars-$KSTARS_VERSION.dmg" > "KStars-$KSTARS_VERSION.dmg.md5"
shasum -a 256 "KStars-$KSTARS_VERSION.dmg" > "KStars-$KSTARS_VERSION.dmg.sha256"

# Clean up
rm -rf "$TMP_DIR"

success "DMG created successfully at $DMG_FILE"
echo
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}KStars DMG creation completed successfully!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo
echo "DMG file: $DMG_FILE"
echo "MD5: $DMG_DIR/KStars-$KSTARS_VERSION.dmg.md5"
echo "SHA256: $DMG_DIR/KStars-$KSTARS_VERSION.dmg.sha256"
echo
