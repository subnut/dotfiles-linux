# NOTE:
# We deliberately don't include any checks for whether we're running as root.
# That's because we don't expect to ever be run as root.
# ie. This prompt has been designed for non-root users.
# Just something to keep in mind.

# If you ever intend to extend this prompt for root, then keep these
# prompt expansions in mind -
# 	%(!.$root.$user)
#	%# => %(!.#.%)
# These might come in handy.

PROMPT=
PROMPT+='$(__mpexec __mpx-ssh grey R)'
PROMPT+='%B[%~]%b '
PROMPT+='$(__mpexec __mpx-pyenv grey R)'

TPROMPT='$__tpnl'
TPROMPT+='$(__mpexec __mpx-pyenv grey R)'
TPROMPT+='%B%~%b'
TPROMPT+='$(__mpexec __mpx-ssh grey L)'
# TPROMPT+='$(__mpexec echoti hpa $((COLUMNS)))'
# TPROMPT+='%(?..$(__mpexec echoti cub ${#?})'
# TPROMPT+='%F{'$__mpcol[lred]'}%B%?%b%f)'
TPROMPT+=$'\n'
TPROMPT+='%B%F{%(?.'$__mpcol[green]'.'$__mpcol[lred]')}$%b%f '

RPROMPT+='%F{%(?.'$__mpcol[grey]'.'$__mpcol[lred]'}'
RPROMPT+='%(?=$(__mpexec __mptime)=%B%?%b)%f'
