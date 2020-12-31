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

# Run a LND node manually
unalias mlnd

mkl() {
  make tags="autopilotrpc signrpc walletrpc chainrpc invoicesrpc routerrpc watchtowerrpc "
}


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

# Edit this file 
alias vip="vi ~/.bash_profile"

# Shorthand unit testing
u () { make unit pkg=$1; }

# Run faraday connected to alice in regtest 
alias frd="/Users/carla/go/src/github.com/lightninglabs/faraday/faraday --lnd.tlscertpath=/Users/carla/dev/network/mounts/regtest/alice/tls.cert --network=regtest --lnd.macaroondir=/Users/carla/dev/network/mounts/regtest/alice --lnd.rpcserver=localhost:10011"

# Run Nautilus
alias naut='nautserver --network=regtest \
  --insecure \
  --bitcoin.host=localhost:18443 \
  --bitcoin.user=kek \
  --bitcoin.password=kek\
  --bitcoin.httppostmode \
  --lnd.host=localhost:10013 \
  --lnd.macaroondir=/Users/carla/dev/network/mounts/regtest/charlie/ \
  --lnd.tlspath=/Users/carla/dev/network/mounts/regtest/charlie/tls.cert \
  --debuglevel=debug \
  --prometheus.active \
  daemon'

# Run loop connecting to the nautilus above
alias lp='loopd --network=regtest \
  --debuglevel=debug \
  --corsorigin=* \
  --server.host=localhost:11009 \
  --server.notls \
  --lnd.host=localhost:10011 \
  --lnd.macaroondir=/Users/carla/dev/network/mounts/regtest/alice/ \
  --lnd.tlspath=/Users/carla/dev/network/mounts/regtest/alice/tls.cert '
