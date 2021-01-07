# Global environment variables
# Local level envs should *not* be set here, rather create vars.sh in relevant dir!
export GOPATH="/Users/carla/go"
export GOMODULES="on"

# Add gopath's bin to path
export PATH=$PATH:/Users/carla/go/bin

# Add protoc to path
export PATH=$PATH:/Users/carla/tools/protoc/bin

# Git tab completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Display path and git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\w \$(parse_git_branch) "

PS2=" 🔪 "

# Useful git scripts (from Joost)
cas () { git commit --fixup $1 && GIT_SEQUENCE_EDITOR=: git rebase --autostash -i $1^ --autosquash; }

ear() { short="$(echo $1 | head -c 7)"; GIT_SEQUENCE_EDITOR="sed -i -e 's/pick $short/edit $short/'" git rebase -i $short~1; }

reword() { short="$(echo $1 | head -c 7)"; GIT_SEQUENCE_EDITOR="sed -i -e 's/pick $short/r $short/'" git rebase -i $short~1; }

editall() { GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/edit/'" git rebase -i $1; }

# shift the times on commits
fixtimes() {
	        export DELTA=10

		        git filter-branch -f --env-filter '
			                GIT_COMMITTER_DATE=`date -d "+$DELTA second"`
					                DELTA=`expr $DELTA + 10`
							        ' --commit-filter 'git commit-tree -S "$@"' $1..HEAD
							}

trybuild() {
    HEAD=`git rev-parse HEAD`
    echo $HEAD
    git rev-list --reverse $1..HEAD | xargs -n1 -I{} sh -c '(echo ---- {} ---- && git checkout {} && make tags="$TAGS" && make unit pkg=./... case=_NONE_ tags="$TAGS") || exit 255'
    git checkout HEAD
}

# get upstream pr
fpr(){
  git fetch origin pull/$1/head:review-$1-$2
  git checkout review-$1-$2
}

# Git one liner logs
alias gl="git log --oneline --decorate"

# Git: Alias signed commits
alias cmt="git commit -S "

# Git: rebase on master with date workartound
alias rbm="git rebase --ignore-date master"

# PGP: GPG time to live 
export GPG_TTY=$(tty)

# PGP: Clear warnings on signature
export LC_ALL=en_US.UTF-8
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Make python not fucking suck
export python="python3"
export pip="pip3"

# Shorthand unit testing
u () { make unit pkg=$1; }
