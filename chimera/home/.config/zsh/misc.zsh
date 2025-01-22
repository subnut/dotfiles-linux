## Disable globbing for certain commands
() { local -a cmds=(
	curl apk	# commands
	gcm gcma	# aliases
)
local _x; for _x in $cmds; do
    if (( ${+commands[$_x]} + ${+functions[$_x]} )); then
        alias $_x="noglob $_x"
    fi
done
}


## Custom functions
compdef tssh=ssh
function tssh {
    local N=0
    (( # )) || {
        ssh; return $?;
    }
    (( # > 1 )) &&
        [[ ${@[$#]} = 0${@[$#]#0} ]] &&
        N=${@[$#]} && set -- "${@[0,$(( # - 1 ))]}"

    ssh -t "$@" tmux new -As$N
}
