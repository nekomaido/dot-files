# Fix TMPDIR for macOS 15.7.1+ (lazygit and other tools need this)
export TMPDIR=$(getconf DARWIN_USER_TEMP_DIR)

# UTF-8 Locale (required for Nerd Font symbols in tmux)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default editor
export EDITOR=nvim

# PATH
export PATH="$PATH:/Users/nekomaido/.local/bin"
export PATH="$HOME/.tmuxifier/bin:$PATH"

# Starship prompt
eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf - fuzzy finder
source <(fzf --zsh)

# Zoxide initialization (smart cd replacement)
eval "$(zoxide init zsh)"

# alias
alias cls='clear'
alias cd='__zoxide_z'
alias zz='builtin cd'

# Fuzzy file opener (like zoxide but for files)
# o  = open file in current directory
# oo = jump to directory (zoxide) then open file
function o() {
  local file
  file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --line-range :100 {}')
  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

function oo() {
  local dir file
  dir=$(zoxide query -i "$@") || return
  file=$(fd --type f --hidden --exclude .git . "$dir" | fzf --preview 'bat --color=always --line-range :100 {}')
  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# TheFuck - command correction
eval $(thefuck --alias)

# Yazi file manager
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Tmuxifier
eval "$(tmuxifier init -)"

# Auto-start tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  # Check if there's an existing tmux session
  if tmux has-session 2>/dev/null; then
    # Attach to the existing session
    exec tmux attach-session
  else
    # Create a new session
    exec tmux new-session
  fi
fi
