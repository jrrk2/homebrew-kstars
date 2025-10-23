# Homebrew KStars

A Homebrew tap for automatically installing KStars and its dependencies on macOS.

## What is this?

This repository contains Homebrew formulas for installing [KStars](https://edu.kde.org/kstars/) and the [INDI Library](https://indilib.org/) on macOS. KStars is a desktop planetarium software that provides an accurate graphical simulation of the night sky, from any location on Earth, at any date and time.

## Installation

### Quick Install

The easiest way to install KStars is to run:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yourusername/homebrew-kstars/master/scripts/install_kstars.sh)"
```

### Manual Installation

If you prefer to install manually:

1. Tap this repository:
   ```bash
   brew tap yourusername/kstars
   ```

2. Install KStars:
   ```bash
   brew install yourusername/kstars/kstars
   ```

## Requirements

- macOS 12 (Monterey) or later
- [Homebrew](https://brew.sh/)
- Approximately 5GB of free disk space

## Features

- Installs all required dependencies automatically
- Configures KStars to work correctly on macOS
- Includes INDI drivers for telescope control
- Creates a properly bundled macOS application

## Creating a DMG

If you want to create a redistributable DMG file:

```bash
CREATE_DMG=1 brew reinstall yourusername/kstars/kstars
```

The DMG will be created on your Desktop.

## Troubleshooting

### Common Issues

- **KStars crashes on startup**: Make sure all dependencies are properly installed. Try running:
  ```bash
  brew reinstall yourusername/kstars/kstars
  ```

- **INDI drivers not found**: KStars should automatically find the INDI drivers. If not, you can manually set the path in KStars settings to:
  ```
  /Applications/KStars.app/Contents/MacOS/indi
  ```

- **Missing icons or themes**: This is usually caused by KDE frameworks issues. Try reinstalling the KDE dependencies:
  ```bash
  brew reinstall KDE-mac/kde/kf5-breeze-icons
  ```

### Getting Help

If you encounter any issues not covered here, please [file an issue](https://github.com/yourusername/homebrew-kstars/issues).

## Credits

- The KStars development team for creating this amazing software
- The INDI Library developers
- Homebrew and the Homebrew community

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

The bundled software (KStars, INDI) is licensed under their respective licenses (GPL).
