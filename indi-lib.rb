class IndiLib < Formula
  desc "Instrument Neutral Distributed Interface for astronomy"
  homepage "https://indilib.org"
  url "https://github.com/indilib/indi/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "df0ca19e537ce63b1d434881a8a4356f82a2cc9c3cf12c270d29310646fec260"
  license "LGPL-2.1-only"
  head "https://github.com/indilib/indi.git", branch: "master"

  bottle do
    root_url "https://github.com/jrrk2/homebrew-kstars/releases/download/indi-lib-2.0.6"
    sha256 arm64_monterey: "c70dcbdfcd143bb91bca07d9d4a00d5d5b12952bfa4c5b3d4b302da8ec01ec4f"
    sha256 monterey: "53aec7b795de48c6e58f9a4d7fa3f9e3b968cc5e342b50f023ebd8aaf9793805"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libnova"
  depends_on "libusb"
  depends_on "cfitsio"
  depends_on "libcurl"
  depends_on "zlib"

  def install
    ENV.cxx11

    # Build libindi
    cd "libindi" do
      system "cmake", ".", *std_cmake_args, 
             "-DBUILD_SHARED_LIBS=ON", 
             "-DUDEVRULES_INSTALL_DIR=#{lib}/udev/rules.d",
             "-DCMAKE_INSTALL_RPATH=#{lib}"
      system "make"
      system "make", "install"
    end

    # Install 3rd party drivers
    cd "drivers" do
      system "cmake", ".", *std_cmake_args, 
             "-DBUILD_SHARED_LIBS=ON", 
             "-DCMAKE_INSTALL_RPATH=#{lib}",
             "-DUDEVRULES_INSTALL_DIR=#{lib}/udev/rules.d"
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      INDI Library has been installed with basic drivers.
      To use INDI with KStars, make sure KStars is properly configured
      to find the INDI server and drivers.
    EOS
  end

  test do
    assert_match "INDI Library", shell_output("#{bin}/indi_getprop -h 2>&1")
    system "#{bin}/indiserver", "-v", "-m", "100"
  end
end
