# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/carla/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode tmux tmuxinator)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function options() {
    PLUGIN_PATH="$HOME/.oh-my-zsh/plugins/"
    for plugin in $plugins; do
        echo "\n\nPlugin: $plugin"; grep -r "^function \w*" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/()//'| tr '\n' ', '; grep -r "^alias" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/=.*//' |  tr '\n' ', '
    done
}


# Migrated from old bash profile
# Global environment variables
export GOPATH="/Users/carla/go"
export GOMODULES="on"

# Add gopath's bin to path
export PATH=$PATH:/Users/carla/go/bin

# Add protoc to path
export PATH=$PATH:/Users/carla/tools/protoc/bin

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

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

bindkey -v

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1
