setopt promptsubst
zmodload zsh/terminfo
(( ${+precmd_functions} ))  || typeset -ga precmd_functions
(( ${+preexec_functions} )) || typeset -ga preexec_functions

typeset -gA __mpcol
__mpcol[red]=1
__mpcol[blue]=4
__mpcol[pink]=5
__mpcol[cyan]=6
__mpcol[grey]=7
__mpcol[green]=2
__mpcol[yellow]=3

if [[ ${terminfo[colors]} -lt 8 ]]
then
	__mpcol[lred]=1
	__mpcol[lblue]=4
	__mpcol[lpink]=5
	__mpcol[lcyan]=6
	__mpcol[lgrey]=7
	__mpcol[lgreen]=2
	__mpcol[lyellow]=3
else
	__mpcol[lred]=9
	__mpcol[lblue]=12
	__mpcol[lpink]=13
	__mpcol[lcyan]=14
	__mpcol[lgrey]=8
	__mpcol[lgreen]=10
	__mpcol[lyellow]=11
fi

# Grey is sometimes nigh invisible in some colorschemes
# So, if 256-colors is available, use 244 instead
if [[ ${terminfo[colors]} -eq 256 ]]; then
	__mpcol[grey]=244
fi


# Helpers
# 1. To run command from prompt without changing exitcode
# 2. To print something after applying prompt expansion on it
function __mpexec { local ec=$?; "$@"; return $ec }
function __mpexpn { print -n -- "${(%)*}" }


## Execution time helper
zmodload zsh/datetime
typeset -gA __mptime
function __mptime {
	local sec out
	(( $__mptime[start1] )) || return
	sec=$(( __mptime[stop0] - __mptime[start0] ))
	[[ $sec -lt 0.01 ]] && return	# insignificant
	if [[ $sec -lt 1 ]]; then
		local nsec=$(( __mptime[stop2] - __mptime[start2] ))
		[[ $nsec -lt 0 ]] && (( nsec += 1000000000 ))	# rollover
		local msec=$(( nsec / 1000000 ))
		out="${msec}ms"
	elif [[ $sec -lt 15 ]]; then
		out="${sec:0:5}s"  # 0.xxx -- 5 chars
	else
		sec=$(( __mptime[stop1] - __mptime[start1] )) out="$(( sec % 60 ))s"
		[[ $(( sec /= 60 )) -gt 0 ]] && out="$(( sec % 60 ))m $out"
		[[ $(( sec /= 60 )) -gt 0 ]] && out="$(( sec % 60 ))h $out"
		[[ $(( sec /= 60 )) -gt 0 ]] && out="$(( sec % 60 ))d $out"
	fi
	if (( # )) && [[ $1 = set ]]
	printf %s "$out"
}
function __mptime_preexec {
	__mptime[start0]=$EPOCHREALTIME
	__mptime[start1]=$epochtime[1]
	__mptime[start2]=$epochtime[2]
}
function __mptime_precmd {
	__mptime[stop0]=$EPOCHREALTIME
	__mptime[stop1]=$epochtime[1]
	__mptime[stop2]=$epochtime[2]
}
preexec_functions+=__mptime_preexec
precmd_functions+=__mptime_precmd


##### EXTENSIONS #####
__mpx-ssh() { (( ${+SSH_CONNECTION} )) && __mpxhp "%n@%m" "$@" }
__mpx-pyenv() { (( ${+VIRTUAL_ENV} )) && __mpxhp "(${VIRTUAL_ENV##*/})" "$@" }


## Extension helper
function __mpxhp {
	# Takes three arguments -
	#   1. The text to print
	#   2. The color to print it in
	#   3. [OPTIONAL] Formatting options
	#
	# The optional argument -
	#   If the argument contains 0, then output isn't colorized
	#   If the argument contains -, then emit backspaces before output
	#   The output is left-padded by the number of L/l in the argument
	#   The output is right-padded by the number of R/r in the argument
	#
	local out="$1" col="$2" opt="$3"
	test ! 0 = "${opt//[^0-9]/}" && out="%F{${__mpcol[$col]}}${out}%f"
	printf %${#opt//[^lL]/}s; printf %s "$out"; printf %${#opt//[^rR]/}s;
}
