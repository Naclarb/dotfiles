# =============================================================================
# 1. Powerlevel10k Instant Prompt (must be near the top)
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# 2. History settings (Zsh syntax)
# =============================================================================
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# =============================================================================
# 3. Environment variables (migrated from .bashrc)
# =============================================================================

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# DeepSeek / Anthropic related
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
# Load secrets (API keys, tokens) from a separate file
if [ -f ~/.env_secret ]; then
    source ~/.env_secret
fi
export ANTHROPIC_MODEL="deepseek-v4-pro"
export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro"
export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
export CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
export CLAUDE_CODE_EFFORT_LEVEL="max"

# Bat theme
export BAT_THEME="GitHub"

# Default browser for WSL
export BROWSER=wslview

# PATH additions
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# 4. Aliases (migrated from .bashrc)
# =============================================================================
alias fd='fdfind'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# =============================================================================
# 5. Tool initializations
# =============================================================================

# zoxide – smarter cd (must use zsh init)
eval "$(zoxide init zsh)"

# =============================================================================
# 6. Zsh plugins (manually sourced)
# =============================================================================
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Fix autosuggestion color (use fg=244 for 256-color terminals)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# Bind arrow keys for substring history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Fix backspace key (delete character)
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char


# =============================================================================
# 7. Powerlevel10k theme
# =============================================================================
source ~/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

# Load custom p10k configuration if present
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh-syntax-highlighting MUST be loaded LAST (it wraps ZLE widgets)
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =============================================================================
# 8. Additional configuration
# =============================================================================

# 自动启动 ssh-agent 并添加私钥
if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# 检查并添加 id_ed25519 私钥
if ! ssh-add -l | grep -q "id_ed25519"; then
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# 启用 vi 模式
bindkey -v
