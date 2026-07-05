#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME="${HOME:-$HOME}"

# ─── Utils ──────────────────────────────────────────────────────────────────
info()  { printf '\033[1;34m•\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m✓\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m⚠\033[0m %s\n' "$1"; }
err()   { printf '\033[1;31m✗\033[0m %s\n' "$1"; }

# ─── Step 1: Symlink dotfiles ───────────────────────────────────────────────
link_dotfile() {
    local src="$REPO_DIR/$1"
    local dst="$HOME/$1"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        ok "symlink $1 already correct"
    elif [ -e "$dst" ]; then
        warn "backing up existing $1 → $1.bak"
        mv "$dst" "$dst.bak"
        ln -sf "$src" "$dst"
        ok "symlinked $1 (backed up original)"
    else
        ln -sf "$src" "$dst"
        ok "symlinked $1"
    fi
}

info "symlinking dotfiles..."
link_dotfile ".zshrc"
link_dotfile ".bashrc"
link_dotfile ".tmux.conf"
link_dotfile ".vimrc"
link_dotfile ".p10k.zsh"

# ─── Step 2: Detect OS / package manager ────────────────────────────────────
if command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt"
elif command -v brew &>/dev/null; then
    PKG_MANAGER="brew"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
else
    PKG_MANAGER=""
fi

install_pkg() {
    local pkg=$1
    case "$PKG_MANAGER" in
        apt)   sudo apt-get install -y "$pkg" ;;
        brew)  brew install "$pkg" ;;
        pacman) sudo pacman -S --noconfirm "$pkg" ;;
    esac
}

# ─── Step 3: Install system packages ────────────────────────────────────────
info "installing system packages..."
case "$PKG_MANAGER" in
    apt)
        sudo apt-get update -qq
        install_pkg zsh
        install_pkg bat
        install_pkg fdfind
        install_pkg tmux
        install_pkg vim
        install_pkg curl
        install_pkg git
        ;;
    brew)
        install_pkg zsh
        install_pkg bat
        install_pkg fd
        install_pkg tmux
        install_pkg vim
        install_pkg curl
        install_pkg git
        ;;
    pacman)
        install_pkg zsh
        install_pkg bat
        install_pkg fd
        install_pkg tmux
        install_pkg vim
        install_pkg curl
        install_pkg git
        ;;
    *)
        warn "unknown package manager — skipping system deps; install zsh, git, bat, fd, tmux, vim manually"
        ;;
esac

# ─── Step 4: zoxide ─────────────────────────────────────────────────────────
if ! command -v zoxide &>/dev/null; then
    info "installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    ok "zoxide already installed"
fi

# ─── Step 5: Powerlevel10k ──────────────────────────────────────────────────
P10K_DIR="${ZSH_CUSTOM:-$HOME/.zsh/themes}/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    info "installing Powerlevel10k..."
    mkdir -p "$(dirname "$P10K_DIR")"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    ok "Powerlevel10k already installed"
fi

# ─── Step 6: Zsh plugins ────────────────────────────────────────────────────
ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

install_zsh_plugin() {
    local name=$1
    local url=$2
    local dir="$ZSH_PLUGIN_DIR/$name"
    if [ ! -d "$dir" ]; then
        info "installing zsh plugin: $name..."
        git clone --depth=1 "$url" "$dir"
    else
        ok "zsh plugin $name already installed"
    fi
}

install_zsh_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-history-substring-search" \
    "https://github.com/zsh-users/zsh-history-substring-search"
install_zsh_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"

# ─── Step 7: NVM ────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
    info "installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    ok "NVM already installed"
fi

# ─── Step 8: .env_secret warning ────────────────────────────────────────────
if [ ! -f "$HOME/.env_secret" ]; then
    warn "~/.env_secret not found — create it with your API keys:"
    echo '  cat > ~/.env_secret <<EOF'
    echo '  export DEEPSEEK_API_KEY="sk-..."'
    echo '  EOF'
    echo '  chmod 600 ~/.env_secret'
fi

# ─── Done ───────────────────────────────────────────────────────────────────
echo ""
info "Installation complete!"
echo ""
echo "  To finish setup:"
echo "    1. Restart your shell or run: exec zsh"
echo "    2. If you use bash as your primary shell, run: chsh -s $(command -v zsh)"
echo "    3. The first time zsh starts, Powerlevel10k will prompt you to configure the prompt style"
echo ""
echo "  Installed configs: .zshrc  .bashrc  .tmux.conf  .vimrc  .p10k.zsh"
echo "  Original files (if any) were backed up with a .bak suffix"
