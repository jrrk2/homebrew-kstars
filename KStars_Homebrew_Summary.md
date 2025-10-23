# KStars on macOS: Custom Homebrew Tap

I've created a complete custom Homebrew tap for automating the installation of KStars on macOS. This solution addresses your requirement to customize Homebrew to automatically install KStars and all its dependencies on a fresh machine.

## What's Included

1. **Custom Homebrew Formulas**:
   - `indi-lib.rb` - Formula for installing the INDI Library
   - `kstars.rb` - Formula for installing KStars with all dependencies

2. **Homebrew Cask**:
   - `kstars-full.rb` - Cask for installing KStars from pre-built DMG

3. **Installation Scripts**:
   - `install_kstars.sh` - Automated script for installing KStars via Homebrew
   - `build_kstars.sh` - Script for building KStars from source
   - `create_dmg.sh` - Script for creating a custom KStars DMG

4. **Documentation**:
   - `README.md` - Comprehensive documentation for users
   - This summary document

5. **GitHub Workflow**:
   - `test-and-build.yml` - GitHub Actions workflow for CI/CD

## How to Use

### Option 1: Quick Installation (Recommended for Most Users)

Run the installation script which will:
1. Tap your custom repository
2. Install all required dependencies
3. Install KStars

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jrrk2/homebrew-kstars/master/scripts/install_kstars.sh)"
```

### Option 2: Manual Installation

1. Tap your repository:
   ```bash
   brew tap jrrk2/kstars https://github.com/jrrk2/homebrew-kstars
   ```

2. Install KStars:
   ```bash
   brew install jrrk2/kstars/kstars
   ```

### Option 3: Building from Source

For more advanced users who want to build from source:

1. Install the build script:
   ```bash
   curl -o build_kstars.sh https://raw.githubusercontent.com/jrrk2/homebrew-kstars/master/scripts/build_kstars.sh
   chmod +x build_kstars.sh
   ```

2. Run the build script (with options):
   ```bash
   ./build_kstars.sh -d -s  # Creates a DMG with stable version
   ```

   Options:
   - `-d`: Build a distributable DMG
   - `-x`: Create an Xcode project
   - `-s`: Build the latest stable version (instead of git master)
   - `-v`: Verbose output

## Hosting Instructions

To make this solution available to others:

1. Create a GitHub repository named `homebrew-kstars`
2. Upload all the files in the output directory to this repository
3. Update all instances of `jrrk2` in the code to your actual GitHub username
4. Add appropriate SHA256 checksums to the cask file once you've built the DMG files

## Customization

You can customize the formulas and scripts as needed:

- **Change Versions**: Update the version numbers in the formulas to use different versions of KStars or INDI
- **Add Dependencies**: Add additional dependencies to the formulas if needed
- **Modify Build Options**: Change the build options in the scripts to customize the build process

## Benefits of This Approach

1. **Fully Automated**: Users can install KStars with a single command
2. **Consistent Installation**: Ensures all dependencies are installed correctly
3. **Easy Updates**: Users can update to new versions easily with `brew upgrade`
4. **Customizable**: You can modify the formulas and scripts as needed
5. **Cross-Platform**: Works on Intel and Apple Silicon Macs
6. **Self-Contained**: Everything is in one repository

## Further Development

You could further enhance this solution by:

1. Adding more INDI drivers as separate formulas
2. Creating bottles (pre-built binaries) for faster installation
3. Adding more customization options to the scripts
4. Creating a website for your tap with installation instructions

## Conclusion

This custom Homebrew tap provides a complete solution for automating the installation of KStars on macOS. It handles all dependencies and provides multiple installation options to accommodate different user needs.

The modular design allows for easy maintenance and updates as new versions of KStars and INDI are released.

All files are available in the output directory for your use.
