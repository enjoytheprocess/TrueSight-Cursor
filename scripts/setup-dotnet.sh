#!/usr/bin/env bash
# Install .NET 9 SDK to ~/.dotnet when the CLI is missing (common on fresh WSL).
set -euo pipefail

DOTNET_INSTALL_DIR="${DOTNET_INSTALL_DIR:-$HOME/.dotnet}"

if command -v dotnet >/dev/null 2>&1; then
  echo "dotnet already on PATH: $(command -v dotnet)"
  dotnet --version
  exit 0
fi

if [[ -x "$DOTNET_INSTALL_DIR/dotnet" ]]; then
  export PATH="$DOTNET_INSTALL_DIR:$PATH"
  echo "dotnet found at $DOTNET_INSTALL_DIR/dotnet"
  dotnet --version
  exit 0
fi

echo "Installing .NET 9 SDK to $DOTNET_INSTALL_DIR ..."
curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh
/tmp/dotnet-install.sh --channel 9.0 --install-dir "$DOTNET_INSTALL_DIR"

export PATH="$DOTNET_INSTALL_DIR:$PATH"
echo ""
echo "Installed: $(dotnet --version)"
echo ""
echo "Add this to your shell profile (~/.bashrc or ~/.zshrc):"
echo "  export PATH=\"\$HOME/.dotnet:\$PATH\""
