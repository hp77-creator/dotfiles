#!/usr/bin/env bash
# =============================================================
#  bootstrap.sh — set up dotfiles on a fresh machine
#  Usage: bash bootstrap.sh
# =============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

echo ""
echo "🚀 Bootstrapping dotfiles from: $DOTFILES_DIR"
echo "   OS detected: $OS"
echo ""

# ── 1. Install core tools ─────────────────────────────────────
echo "📦 Installing core tools..."

if [ "$OS" = "Darwin" ]; then
    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        echo "  Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install neovim tmux stow git

elif [ "$OS" = "Linux" ]; then
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y neovim tmux stow git curl
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm neovim tmux stow git curl
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y neovim tmux stow git curl
    fi
fi

# ── 2. Apply dotfiles via stow ────────────────────────────────
echo ""
echo "🔗 Creating symlinks with stow..."

cd "$DOTFILES_DIR"

stow --restow nvim  && echo "  ✅ nvim  → ~/.config/nvim"
stow --restow tmux  && echo "  ✅ tmux  → ~/.tmux.conf"

# ── 3. Install TPM (tmux plugin manager) ─────────────────────
echo ""
echo "🔌 Setting up tmux plugins..."

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "  ✅ TPM installed"
else
    echo "  ✅ TPM already installed"
fi

echo "  ⏳ Open tmux and press Ctrl+a then I to install tmux plugins"

# ── 4. Install Nerd Font (macOS only) ─────────────────────────
if [ "$OS" = "Darwin" ]; then
    echo ""
    echo "🔤 Installing JetBrainsMono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
    echo "  ✅ Font installed — set it in your terminal: JetBrainsMono Nerd Font"
else
    echo ""
    echo "🔤 On Linux, install a Nerd Font manually:"
    echo "   https://www.nerdfonts.com/font-downloads"
    echo "   Recommended: JetBrainsMono Nerd Font"
fi

# ── 5. Done ───────────────────────────────────────────────────
echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Set JetBrainsMono Nerd Font in your terminal app"
echo "  2. Open tmux → press Ctrl+a then I to install plugins"
echo "  3. Open nvim → lazy.nvim will auto-install plugins"
echo "     Then run: :TSUpdate   (compile treesitter parsers)"
echo "     Then run: :Mason      (install LSP servers)"
echo ""
