# vim: nowrap
zstyle :compinstall filename "${ZDOTDIR}/compconf.zsh"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# The following lines were added by compinstall
zstyle ':completion:*' auto-description '(argument: %d)'
zstyle ':completion:*' completer _list _expand _complete _ignored _match _approximate _prefix
zstyle ':completion:*' condition false
zstyle ':completion:*' format '%B[%d]%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' match-original both
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-/]=** r:|=**'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' menu select
zstyle ':completion:*' prompt 'Errors: %e'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"
# End of lines added by compinstall
