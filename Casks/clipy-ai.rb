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
  version "1.1.1"
  sha256 "f9bfd092c466c0f066c212e05fa822b094b4e2af45c3668feef0dcdaff9cbabd"

  # REPLACE with your real download URL. Homebrew needs a URL that resolves per
  # release — either the versioned filename below, or a stable "latest" path.
  url "https://REPLACE-WITH-YOUR-SITE/download/Clipy-#{version}.dmg"
  name "Clipy"
  desc "Clipboard manager with snippet expansion and AI transforms"
  homepage "https://REPLACE-WITH-YOUR-SITE/"

  # Matches LSMinimumSystemVersion (13.0) in Resources/Info.plist.
  depends_on macos: ">= :ventura"

  app "Clipy.app"

  uninstall quit: "com.clipy.app"

  # Note: this path is shared with the original Clipy, so `brew uninstall --zap`
  # would take the other app's data with it on a machine that has both.
  zap trash: [
    "~/Library/Application Support/Clipy",
    "~/Library/Preferences/com.clipy.app.plist",
  ]
end
