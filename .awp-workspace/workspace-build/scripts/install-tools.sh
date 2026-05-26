#!/usr/bin/env bash

set -euo pipefail

# Install yq (mikefarah/yq v4) from the latest GitHub release.
# Downloads the appropriate binary for the current OS and architecture.
# Installs to ~/.local/bin/yq by default; override with YQ_INSTALL_DIR.

YQ_INSTALL_DIR="${YQ_INSTALL_DIR:-$HOME/.local/bin}"
YQ_RELEASES_URL="https://github.com/mikefarah/yq/releases/latest/download"

# ---------------------------------------------------------------------------
# Detect OS and arch
# ---------------------------------------------------------------------------
os=""
arch=""

case "$(uname -s)" in
  Linux)  os="linux"  ;;
  Darwin) os="darwin" ;;
  *)
    echo "ERROR: unsupported OS '$(uname -s)'. Install yq manually: https://github.com/mikefarah/yq" >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64)          arch="amd64" ;;
  arm64|aarch64)   arch="arm64" ;;
  *)
    echo "ERROR: unsupported architecture '$(uname -m)'. Install yq manually: https://github.com/mikefarah/yq" >&2
    exit 1
    ;;
esac

binary="yq_${os}_${arch}"
url="${YQ_RELEASES_URL}/${binary}"
dest="${YQ_INSTALL_DIR}/yq"

# ---------------------------------------------------------------------------
# Download and install
# ---------------------------------------------------------------------------
echo "Downloading yq (${os}/${arch}) from latest release..."
mkdir -p "$YQ_INSTALL_DIR"

if command -v curl &>/dev/null; then
  curl -fsSL "$url" -o "$dest"
elif command -v wget &>/dev/null; then
  wget -qO "$dest" "$url"
else
  echo "ERROR: curl or wget is required to download yq." >&2
  exit 1
fi

chmod +x "$dest"

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
if ! "$dest" --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: downloaded binary does not look like yq v4+. Check $dest manually." >&2
  exit 1
fi

echo "Installed: $("$dest" --version)"
echo "Location:  $dest"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$YQ_INSTALL_DIR"; then
  echo ""
  echo "NOTE: $YQ_INSTALL_DIR is not in your PATH."
  echo "Add this to your shell profile:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ---------------------------------------------------------------------------
# Install Graphviz
# ---------------------------------------------------------------------------
echo ""
echo "Checking for Graphviz (dot)..."

if command -v dot &>/dev/null; then
  echo "Graphviz already installed: $(dot -V 2>&1)"
else
  echo "Installing Graphviz..."
  case "$os" in
    linux)
      if command -v apt-get &>/dev/null; then
        sudo apt-get install -y graphviz
      elif command -v dnf &>/dev/null; then
        sudo dnf install -y graphviz
      elif command -v yum &>/dev/null; then
        sudo yum install -y graphviz
      else
        echo "ERROR: no supported package manager found (apt/dnf/yum). Install graphviz manually: https://graphviz.org/download/" >&2
        exit 1
      fi
      ;;
    darwin)
      if command -v brew &>/dev/null; then
        brew install graphviz
      else
        echo "ERROR: Homebrew not found. Install it first (https://brew.sh) or install graphviz manually: https://graphviz.org/download/" >&2
        exit 1
      fi
      ;;
  esac

  if ! command -v dot &>/dev/null; then
    echo "ERROR: graphviz installation failed. Install manually: https://graphviz.org/download/" >&2
    exit 1
  fi
  echo "Installed: $(dot -V 2>&1)"
fi
