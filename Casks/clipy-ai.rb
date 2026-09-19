# Homebrew cask for Clipy — published from YOUR OWN tap, not homebrew-cask.
#
# WHY A PERSONAL TAP, AND WHY THE TOKEN ISN'T "clipy":
#
#   1. The token `clipy` is already taken by the original open-source Clipy
#      (tap homebrew/cask, bundle id com.clipy-app.Clipy, clipy-app.com,
#      1.3.0, ~11.9k installs/year). `brew install --cask clipy` installs THAT
#      app, not this one. A distinct token is mandatory, not stylistic.
#
#   2. Homebrew ended support for casks that fail Gatekeeper checks on
#      1 September 2026 and is removing the `--no-quarantine` bypass
#      (Homebrew/brew#20755). An unnotarized app can't go into homebrew-cask,
#      and Homebrew will NOT spare users the Gatekeeper prompt. This cask only
#      makes install/upgrade convenient — INSTALL.md is still required.
#
#   3. Clipy.app collides with the original app: same /Applications/Clipy.app
#      path and the same ~/Library/Application Support/Clipy data folder. A
#      machine with the original installed cannot host this one alongside it.
#      Homebrew will refuse to install over an existing /Applications/Clipy.app.
#
# PUBLISHING (once):
#   1. Create a public repo named `homebrew-clipy` under your GitHub account.
#   2. Put this file at Casks/clipy-ai.rb in it.
#   3. Users then run:  brew install --cask arunb1212/clipy/clipy-ai
#
# EACH RELEASE: rebuild, upload, then update `version` and `sha256` (and the URL
# if it moved). Take the checksum from the file you actually uploaded — a rebuilt
# DMG has a different hash, and a stale one breaks installs with a checksum
# mismatch:
#   SIGNING=adhoc ./release.sh && shasum -a 256 build/release/Clipy-<version>.dmg
#
# Once you notarize with a Developer ID, submit a cask to homebrew-cask with an
# unused token — then users get a plain `brew install --cask <token>` with no tap.

cask "clipy-ai" do
  version "1.1.4"
  sha256 "bfe9d51026e127867a74f8807feb7096a4110e465506a24ea7b7a65bf8bb857a"

  # Served from the site (Vercel). The filename carries the version, so a new
  # release needs no edit here beyond `version` and `sha256` — upload
  # Clipy-X.Y.Z.dmg to the site's downloads folder and bump both.
  #
  # The same file is mirrored on GitHub Releases as a backup:
  #   https://github.com/arunb1212/homebrew-clipy/releases/download/v#{version}/Clipy-#{version}.dmg
  url "https://www.tryclipy.online/downloads/Clipy-#{version}.dmg"
  name "Clipy"
  desc "Clipboard manager with snippet expansion and AI transforms"
  homepage "https://www.tryclipy.online/"

  # Matches LSMinimumSystemVersion (13.0) in Resources/Info.plist.
  # Use the symbol form — the string comparison form ("&gt;= :ventura") is
  # deprecated and warns on every brew command for this tap.
  depends_on macos: :ventura

  app "Clipy.app"

  uninstall quit: "com.clipy.app"

  # Note: this path is shared with the original Clipy, so `brew uninstall --zap`
  # would take the other app's data with it on a machine that has both.
  zap trash: [
    "~/Library/Application Support/Clipy",
    "~/Library/Preferences/com.clipy.app.plist",
  ]
end
