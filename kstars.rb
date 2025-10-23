class Kstars < Formula
  desc "Desktop planetarium software for KDE"
  homepage "https://edu.kde.org/kstars/"
  url "https://download.kde.org/stable/kstars/kstars-3.7.9.tar.xz"
  sha256 "32c6eda2b38bbe629c73883e46dc97acb13a8a1227f8d2ca2abe1b728a13775d"
  license "GPL-2.0-or-later"
  
  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "kdoctools" => :build
  depends_on "pkg-config" => :build

  depends_on "cfitsio"
  depends_on "eigen"
  depends_on "gsl"
  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kconfig"
  depends_on "KDE-mac/kde/kf5-kdoctools"
  depends_on "KDE-mac/kde/kf5-kio"
  depends_on "KDE-mac/kde/kf5-knewstuff"
  depends_on "KDE-mac/kde/kf5-knotifications"
  depends_on "KDE-mac/kde/kf5-knotifyconfig"
  depends_on "KDE-mac/kde/kf5-kplotting"
  depends_on "KDE-mac/kde/kf5-ktexteditor"
  depends_on "KDE-mac/kde/kf5-kxmlgui"
  depends_on "libnova"
  depends_on "libraw"
  depends_on "qtkeychain"
  depends_on "qt"
  depends_on "yourusername/kstars/indi-lib"
  depends_on "wcslib"
  depends_on "xplanet" => :optional

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_TESTING=OFF",
                    "-DBUILD_DOC=OFF",
                    "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}",
                    "-DQt5_DIR=#{Formula["qt"].opt_prefix}/lib/cmake/Qt5",
                    "-DQt5Core_DIR=#{Formula["qt"].opt_prefix}/lib/cmake/Qt5Core",
                    "-DQt5Gui_DIR=#{Formula["qt"].opt_prefix}/lib/cmake/Qt5Gui",
                    "-DQt5Widgets_DIR=#{Formula["qt"].opt_prefix}/lib/cmake/Qt5Widgets",
                    "-DCMAKE_INSTALL_RPATH=#{lib}"
                    
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix bundle structure for macOS
    mkdir_p "#{bin}/KStars.app/Contents/Resources/data"
    mkdir_p "#{bin}/KStars.app/Contents/MacOS/indi"
    mkdir_p "#{bin}/KStars.app/Contents/Resources/icons"
    
    # Copy necessary data files
    cp_r "#{Formula["KDE-mac/kde/kf5-breeze-icons"].opt_share}/icons/breeze/breeze-icons.rcc", "#{bin}/KStars.app/Contents/Resources/icons/"
    cp_r "#{Formula["KDE-mac/kde/kf5-breeze-icons"].opt_share}/icons/breeze-dark/breeze-icons-dark.rcc", "#{bin}/KStars.app/Contents/Resources/icons/"
    
    # Copy INDI executables
    cp Dir.glob("#{Formula["yourusername/kstars/indi-lib"].opt_bin}/indi*"), "#{bin}/KStars.app/Contents/MacOS/indi/"
    
    # Update bundle Info.plist
    system "/usr/libexec/PlistBuddy", "-c", "Set :CFBundleShortVersionString #{version}",
           "#{bin}/KStars.app/Contents/Info.plist"
    system "/usr/libexec/PlistBuddy", "-c", "Set :CFBundleVersion #{version}",
           "#{bin}/KStars.app/Contents/Info.plist"
    system "/usr/libexec/PlistBuddy", "-c", 
           "Set :NSHumanReadableCopyright 'KStars Team - Released under GNU GPL'",
           "#{bin}/KStars.app/Contents/Info.plist"
  end

  def post_install
    # Generate a DMG if requested
    if ENV["CREATE_DMG"] == "1"
      system "hdiutil", "create", "-volname", "KStars-#{version}", "-srcfolder", 
             "#{bin}/KStars.app", "#{ENV["HOME"]}/Desktop/KStars-#{version}.dmg"
    end
  end

  def caveats
    <<~EOS
      KStars.app was installed to:
        #{bin}/KStars.app
      
      You can also create a DMG file by running:
        CREATE_DMG=1 brew reinstall kstars
      
      The DMG will be created on your Desktop.
    EOS
  end

  test do
    assert_predicate bin/"KStars.app/Contents/MacOS/kstars", :exist?
  end
end
