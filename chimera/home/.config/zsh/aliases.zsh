alias exists='command -v >/dev/null'
alias py=python3

alias ls='ls -F'
alias l='ls -lAF -h'
alias l.='ls -ldAF .*'
alias ls.='ls -dAF .*'

exists fd && alias fd='LS_COLORS= fd'
exists bat && alias batp='bat --style=header-filename'
exists ncdu && alias ncdu='ncdu --color off'
exists diff && diff --color - - && {
	alias colordiff='diff --color=always'
	alias diff='diff --color'
}

exists rg && {
	alias rg='rg -.'
	alias rgs='rg -s'	# case-sensitive
	alias rgi='rg -i'	# case-insensitive
	alias rgl='rg -l'
	alias rgls='rgl -s'	# case-sensitive
	alias rgli='rgl -i'	# case-insensitive
	alias rgh='rg --no-heading'
	alias rghs='rgh -s'	# case-sensitive
	alias rghi='rgh -i'	# case-insensitive
}

exists git && {
	alias g=git
	alias gsw='git switch'
	alias gst='git status'
	alias gsts='git status -bs'
	alias ga='git add'
	alias gai='git add -i'
	alias gaa='git add --all'
	alias gaav='git add --all --verbose'
	alias gc='git commit -v'
	alias gca='git commit -va'
	gcm()  { git commit -v  -m "$*"; }
	gcma() { git commit -va -m "$*"; }
	alias gp='git push'
	alias gpull='git pull'
	alias gfetch='git fetch'
	alias gpfwl='git push --force-with-lease'
	gpf() {
		>&2 echo DO NOT USE --force
		>&2 echo Use --force-with-lease instead
		return 1
	}
	alias gd='git diff --patience'
	alias gds='gd --staged'
	alias gdh='gd @'
	alias gdh1='gd @^ @'
	ginit() {
		git init
		git commit --allow-empty -m 'git init'
	}
	alias gl='git log --oneline --graph'
	alias glog='git log --stat'
	alias glogp='git log --stat --patch'
	gbl() { git blame -s "$@" | sed 's/ / │ /;s/)/│/' | less; }
	# alias gbl='git blame -s'

	# See gitrevisions(7)
	#
	# - To list the last 5 commits
	# 	git log @~5..
	# 
	# - To list the commits since we branched from 'main'
	# 	git log main..
	# 
	# - To list the commits in 'dev' since it branched from us
	# 	git log ..dev
	# 
	# - To list the commits in 'dev' and 'main' since they branched
	# 	git log main...dev --left-right
}


# NOTE: This file must always end with true
# That cancels out the possibility of any of the [] above returning false
# which would start the shell with an initial exitcode of 1, which isn't good.
true
