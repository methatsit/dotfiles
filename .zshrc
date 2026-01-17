# --- 1. Basic Settings ---
export TERM="xterm-256color"
export EDITOR="nvim"
export QT_QPA_PLATAFORM=wayland qutebrowser
setopt prompt_subst

# --- 2. Color Definitions ---
# We use native Zsh codes (%F) which are faster and don't require plugins
turquoise="%F{220}"
orange="%F{166}"
purple="%F{245}"
hotpink="%F{196}"
limegreen="%F{118}"
reset="%f"

# --- 3. Git Prompt Logic ---
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true

FMT_BRANCH=" on ${turquoise}%b%u%c${reset}"
FMT_ACTION=" performing a ${limegreen}%a${reset}"
FMT_UNSTAGED="${orange} ●"
FMT_STAGED="${limegreen} ●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${reset} on ${turquoise}%b%u%c${hotpink} ●${reset}"
  else
    FMT_BRANCH="${reset} on ${turquoise}%b%u%c${reset}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"

  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

PR_GIT_UPDATE=1
autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

# --- 4. The Prompt ---
PROMPT="${purple}%n${reset} in ${limegreen}%~${reset}\$vcs_info_msg_0_ ${orange}λ${reset} "

# --- 5. Keybindings ---
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history
bindkey '^r' history-incremental-search-backward
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey '^[d' kill-word
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^k' kill-line
bindkey '^l' clear-screen
bindkey '^_' undo
bindkey '^xu' undo
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# --- 6. History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --- 7. Plugins & Styles ---
# Only load these if the files actually exist
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
autoload -Uz compinit && compinit

# Force Orange Text for everything you type
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=208,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=208'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=208'
ZSH_HIGHLIGHT_STYLES[assign]='fg=208'

# Load Angular CLI autocompletion from static file
[[ -f ~/.zsh_ng_completion ]] && source ~/.zsh_ng_completion
