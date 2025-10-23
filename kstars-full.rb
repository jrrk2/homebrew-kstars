cask "kstars-full" do
  version "3.7.9"
  
  if Hardware::CPU.arm?
    sha256 "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
    url "https://www.indilib.org/jdownloads/kstars/kstars-#{version}-arm64.dmg",
        verified: "indilib.org/jdownloads/"
  else
    sha256 "1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z"
    url "https://www.indilib.org/jdownloads/kstars/kstars-#{version}-x86_64.dmg",
        verified: "indilib.org/jdownloads/"
  end

  name "KStars"
  desc "Desktop planetarium software with INDI telescope control"
  homepage "https://edu.kde.org/kstars/"
  
  depends_on macos: ">= :monterey"

  app "KStars.app"
  
  livecheck do
    url "https://edu.kde.org/kstars/"
    regex(/KStars\s+(\d+(?:\.\d+)+)/i)
  end

  zap trash: [
    "~/Library/Application Support/kstars",
    "~/Library/Caches/kstars",
    "~/Library/Preferences/kstars",
    "~/Library/Saved Application State/org.kde.kstars.savedState"
  ]
  
  caveats do
    <<~EOS
      KStars has been installed with full INDI support.
      
      If you need to install additional INDI drivers or customize your installation,
      please visit our Homebrew tap repository:
      
      https://github.com/jrrk2/homebrew-kstars
    EOS
  end
end
