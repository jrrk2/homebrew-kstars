#!/bin/bash
# build_kstars.sh - A script to build KStars from source on macOS
# This script automates the process of building KStars from source

set -e  # Exit immediately if a command exits with a non-zero status

echo "KStars Source Build for macOS"
echo "============================="
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

# Parse command line options
BUILD_DMG=0
BUILD_XCODE=0
BUILD_STABLE=0
VERBOSE=0

while getopts "dxsvh" opt; do
  case ${opt} in
    d )
      BUILD_DMG=1
      ;;
    x )
      BUILD_XCODE=1
      ;;
    s )
      BUILD_STABLE=1
      ;;
    v )
      VERBOSE=1
      ;;
    h )
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  -d    Build a distributable DMG"
      echo "  -x    Create an Xcode project"
      echo "  -s    Build the latest stable version (instead of git master)"
      echo "  -v    Verbose output"
      echo "  -h    Show this help message"
      exit 0
      ;;
    \? )
      error "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
  esac
done

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
KSTARS_BUILD_DIR=${KSTARS_DIR}/build
KSTARS_XCODE_DIR=${KSTARS_DIR}/xcode
KSTARS_SRC_DIR=${KSTARS_DIR}/src
KSTARS_DMG_DIR=${ASTRO_ROOT}/KStarsDMG
GSC_DIR=${ASTRO_ROOT}/gsc

status "Setting up directories..."
mkdir -p ${INDI_DIR}
mkdir -p ${KSTARS_DIR}
mkdir -p ${KSTARS_BUILD_DIR}
mkdir -p ${KSTARS_SRC_DIR}
mkdir -p ${GSC_DIR}
mkdir -p ${KSTARS_DMG_DIR}
if [ ${BUILD_XCODE} -eq 1 ]; then
  mkdir -p ${KSTARS_XCODE_DIR}
fi
success "Directories created"

# Install build dependencies
status "Installing build dependencies..."
brew update
brew install cmake
brew install extra-cmake-modules
brew install qt
brew install gettext
brew link --force gettext
brew tap KDE-mac/kde
brew install KDE-mac/kde/kf5-kconfig
brew install KDE-mac/kde/kf5-kwidgetsaddons
brew install KDE-mac/kde/kf5-kcompletion
brew install KDE-mac/kde/kf5-kjobwidgets
brew install KDE-mac/kde/kf5-kwindowsystem
brew install KDE-mac/kde/kf5-karchive
brew install KDE-mac/kde/kf5-solid
brew install KDE-mac/kde/kf5-sonnet
brew install KDE-mac/kde/kf5-attica
brew install KDE-mac/kde/kf5-kservice
brew install KDE-mac/kde/kf5-kdoctools
brew install KDE-mac/kde/kf5-kauth
brew install KDE-mac/kde/kf5-kcodecs
brew install KDE-mac/kde/kf5-kconfigwidgets
brew install KDE-mac/kde/kf5-kdbusaddons
brew install KDE-mac/kde/kf5-ki18n
brew install KDE-mac/kde/kf5-kiconthemes
brew install KDE-mac/kde/kf5-kitemviews
brew install KDE-mac/kde/kf5-ktextwidgets
brew install KDE-mac/kde/kf5-kglobalaccel
brew install KDE-mac/kde/kf5-kxmlgui
brew install KDE-mac/kde/kf5-kbookmarks
brew install KDE-mac/kde/kf5-kio
brew install KDE-mac/kde/kf5-knotifications
brew install KDE-mac/kde/kf5-kcrash
brew install KDE-mac/kde/kf5-kparts
brew install KDE-mac/kde/kf5-kplotting
brew install KDE-mac/kde/kf5-kwallet
brew install KDE-mac/kde/kf5-kdnssd
brew install KDE-mac/kde/kf5-knotifyconfig
brew install KDE-mac/kde/kf5-knewstuff
brew install KDE-mac/kde/kf5-kded
brew install KDE-mac/kde/kf5-breeze-icons
brew install eigen
brew install cfitsio
brew install gsl
brew install libnova
brew install libraw
brew install qtkeychain
brew install wcslib
brew install xplanet
success "Build dependencies installed"

# Build INDI
status "Building INDI..."
cd ${INDI_DIR}
if [ ! -d "indi" ]; then
  git clone https://github.com/indilib/indi.git
else
  cd indi
  git pull
  cd ..
fi

cd indi/libindi
mkdir -p build
cd build

# Configure and build INDI
cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_MACOSX_RPATH=1 ..
make -j$(sysctl -n hw.ncpu)
sudo make install

success "INDI built and installed"

# Build KStars
status "Building KStars..."
cd ${KSTARS_SRC_DIR}

# Clone KStars source
if [ ${BUILD_STABLE} -eq 1 ]; then
  # Download the latest stable release
  if [ ! -d "kstars" ]; then
    git clone -b stable https://invent.kde.org/education/kstars.git
  else
    cd kstars
    git fetch
    git checkout stable
    git pull
    cd ..
  fi
else
  # Use master branch
  if [ ! -d "kstars" ]; then
    git clone https://invent.kde.org/education/kstars.git
  else
    cd kstars
    git fetch
    git checkout master
    git pull
    cd ..
  fi
fi

cd kstars

# Set build type
if [ ${BUILD_XCODE} -eq 1 ]; then
  status "Creating Xcode project..."
  cd ${KSTARS_XCODE_DIR}
  
  cmake -GXcode \
        -DCMAKE_PREFIX_PATH=/usr/local \
        -DCMAKE_INSTALL_PREFIX=/Applications/KDE \
        -DCMAKE_BUILD_TYPE=Debug \
        -DBUILD_TESTING=OFF \
        ${KSTARS_SRC_DIR}/kstars
  
  success "Xcode project created at ${KSTARS_XCODE_DIR}"
  success "You can now open the project in Xcode"
else
  status "Building KStars with CMake..."
  cd ${KSTARS_BUILD_DIR}
  
  cmake -DCMAKE_PREFIX_PATH=/usr/local \
        -DCMAKE_INSTALL_PREFIX=/Applications/KDE \
        -DCMAKE_BUILD_TYPE=Debug \
        -DBUILD_TESTING=OFF \
        ${KSTARS_SRC_DIR}/kstars
  
  make -j$(sysctl -n hw.ncpu)
  sudo make install
  
  success "KStars built and installed"
  
  # Fix application bundle
  status "Fixing application bundle..."
  KSTARS_APP="/Applications/KDE/kstars.app"
  
  # Copy necessary resources
  mkdir -p "${KSTARS_APP}/Contents/Resources/data"
  cp -r "/usr/local/share/kstars/"* "${KSTARS_APP}/Contents/Resources/data/"
  
  # Copy INDI executables
  mkdir -p "${KSTARS_APP}/Contents/MacOS/indi"
  cp /usr/local/bin/indi* "${KSTARS_APP}/Contents/MacOS/indi/"
  
  # Copy breeze icons
  mkdir -p "${KSTARS_APP}/Contents/Resources/icons"
  cp -f "$(brew --prefix)/share/icons/breeze/breeze-icons.rcc" "${KSTARS_APP}/Contents/Resources/icons/"
  cp -f "$(brew --prefix)/share/icons/breeze-dark/breeze-icons-dark.rcc" "${KSTARS_APP}/Contents/Resources/icons/"
  
  success "Application bundle fixed"
  
  # Create DMG if requested
  if [ ${BUILD_DMG} -eq 1 ]; then
    status "Creating DMG..."
    KSTARS_VERSION=$(grep "KSTARS_VERSION " ${KSTARS_SRC_DIR}/kstars/kstars/version.h | awk '{print $3}' | tr -d '"')
    
    # Create DMG
    hdiutil create -volname "KStars-${KSTARS_VERSION}" \
                  -srcfolder "${KSTARS_APP}" \
                  -ov -format UDZO \
                  "${KSTARS_DMG_DIR}/KStars-${KSTARS_VERSION}.dmg"
    
    # Create checksum files
    cd ${KSTARS_DMG_DIR}
    md5 "KStars-${KSTARS_VERSION}.dmg" > "KStars-${KSTARS_VERSION}.dmg.md5"
    shasum -a 256 "KStars-${KSTARS_VERSION}.dmg" > "KStars-${KSTARS_VERSION}.dmg.sha256"
    
    success "DMG created at ${KSTARS_DMG_DIR}/KStars-${KSTARS_VERSION}.dmg"
  fi
fi

echo
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}KStars build completed successfully!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo

if [ ${BUILD_XCODE} -eq 1 ]; then
  echo "Xcode project is available at: ${KSTARS_XCODE_DIR}"
  echo "Open the project with: open ${KSTARS_XCODE_DIR}/KStars.xcodeproj"
else
  echo "KStars.app has been installed to: /Applications/KDE/kstars.app"
fi

if [ ${BUILD_DMG} -eq 1 ]; then
  echo "DMG file is available at: ${KSTARS_DMG_DIR}/KStars-${KSTARS_VERSION}.dmg"
fi

echo
echo "If you encounter any issues, please report them at:"
echo "https://github.com/yourusername/homebrew-kstars/issues"
