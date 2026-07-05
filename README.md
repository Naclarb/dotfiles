# dotfiles

Personal dotfiles for my development environment — Zsh, Bash, Tmux, Vim, and Powerlevel10k.

## What's included

| File | What it configures |
|---|---|
| `.zshrc` | Zsh shell: history, aliases, plugins (autosuggestions, syntax highlighting, history search), zoxide, NVM, Powerlevel10k prompt |
| `.bashrc` | Bash shell: prompt, aliases, completions, zoxide, NVM (fallback shell config) |
| `.tmux.conf` | Tmux: mouse support, 256-color, scroll/navigate with mouse wheel |
| `.vimrc` | Vim: line numbers, auto-indent, 4-space tabs, syntax highlighting |
| `.p10k.zsh` | Powerlevel10k prompt theme config |
| `install.sh` | One-shot bootstrap: symlinks configs, installs packages, sets up plugins |

## Prerequisites

- **OS**: Linux (apt/pacman) or macOS (Homebrew)
- **Git** (to clone)
- **curl** (for zoxide and NVM installers)

## Quick start

```bash
git clone https://github.com/Naclarb/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Symlink each dotfile to `$HOME` (backing up existing ones with `.bak`)
2. Detect your package manager and install: `zsh`, `bat`, `fd`/`fdfind`, `tmux`, `vim`, `curl`, `git`
3. Install [zoxide](https://github.com/ajeetdsouza/zoxide) (smart `cd`)
4. Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
5. Install Zsh plugins: autosuggestions, history substring search, syntax highlighting
6. Install [NVM](https://github.com/nvm-sh/nvm)
7. Warn if `~/.env_secret` is missing

After install, restart your shell or run `exec zsh`.

## Secrets

API keys and tokens live in `~/.env_secret` (not tracked in git):

```bash
cat > ~/.env_secret <<'EOF'
export DEEPSEEK_API_KEY="sk-..."
EOF
chmod 600 ~/.env_secret
```

## Notes

- Zsh plugins are sourced manually (no Oh My Zsh dependency)
- zsh-syntax-highlighting is loaded last (it wraps ZLE widgets)
- `.env_secret` is sourced from both `.zshrc` and `.bashrc`
- The p10k config is shared between Zsh and Bash

## License

[MIT](LICENSE)
