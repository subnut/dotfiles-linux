(( ${+TPROMPT} ))   || return 0
[[ -c /dev/null ]]  || return 0
zmodload zsh/system || return 0

__tp_prompt=$PROMPT
__tp_rprompt=$RPROMPT
__tp_tprompt=$TPROMPT
PROMPT=$TPROMPT

(( ${+preexec_functions} )) || typeset -ga preexec_functions
(( ${+precmd_functions}  )) || typeset -ga precmd_functions
(( ${#precmd_functions}  )) || { precmd_functions=(:) }

# Rename existing wid
if zle -la zle-line-finish
then zle -A zle-line-finish __tp0wid_zlfn
else zle -N __tp0wid_zlfn; __tp0wid_zlfn() {:}; fi
zle -la send-break   && zle -A send-break   __tp0wid_sbrk || zle -A .send-break   __tp0wid_sbrk
zle -la clear-screen && zle -A clear-screen __tp0wid_clsr || zle -A .clear-screen __tp0wid_clsr

# Create new wid
zle -N send-break       __tpwid_sbrk
zle -N clear-screen     __tpwid_clsr
zle -N zle-line-finish  __tpwid_zlfn

__tpwid_sbrk() { __tpwid_zlfn;	zle __tp0wid_sbrk; }
__tpwid_clsr() { __tpnl=;	zle __tp0wid_clsr; }
__tpwid_zlfn() {
	zle && zle __tp0wid_zlfn
	(( ! __tpfd )) && {
		sysopen -r -o cloexec -u __tpfd /dev/null
		zle -F $__tpfd  __tprestore
	};
	RPROMPT=
	PROMPT=$__tp_prompt
	zle reset-prompt
	zle -R
}
TRAPINT() { zle && __tpwid_zlfn; return $(( 128 + $1 )); }
__tpset() { PROMPT=$TPROMPT RPROMPT=$__tp_rprompt }
__tprestore() {
	exec {1}>&-
	(( ${+1} )) && zle -F $1
	__tpfd=0; __tpset;
	zle reset-prompt
	zle -R
}
__tpcmdpre() { __tpcmdpre() { __tpnl=$'\n' }}
precmd_functions+=__tpcmdpre
export __tpnl
