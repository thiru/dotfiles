# Fix duplicated text after tab-completion
export LC_CTYPE=en_US.UTF-8

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz compinit promptinit
compinit
promptinit

# Bash completion (originally added for pipenv completion)
autoload bashcompinit && bashcompinit

# Zsh hook support
autoload -U add-zsh-hook

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt autocd
setopt completealiases
setopt HIST_IGNORE_DUPS
setopt COMPLETE_ALIASES

source ~/.config/shell/base.sh
source ~/.config/shell/aliases.sh
source ~/.config/shell/functions.sh
[[ -f ~/.config/shell/extras.sh ]] && source ~/.config/shell/extras.sh

# Change window title to current directory when changed
set_window_title_on_cd() {
  if [[ -n "$NVIM" ]]; then
    curr_dir=`print -rD $PWD`
    nvim --server "$NVIM" --remote-send "<cmd>lua vim.opt.titlestring='$curr_dir'<CR>"
  else
    echo -e "\e]2;$curr_dir\007";
  fi
}
add-zsh-hook chpwd set_window_title_on_cd

# AWS CLI completion:
if [ -f '/usr/bin/aws_completer' ]; then
  complete -C '/usr/bin/aws_completer' aws
fi

# pipenv completion [START]:

_pipenv-pipes_completions() {
COMPREPLY=($(compgen -W "$(pipes --_completion)" -- "${COMP_WORDS[1]}"))
}

complete -F _pipenv-pipes_completions pipes

# pipenv completion [END]

# Remember visited directories [START]:

if [ ! -d "$HOME/.cache/zsh" ]; then
  mkdir ~/.cache/zsh
fi

DIRSTACKFILE="$HOME/.cache/zsh/dirs"

if [ -f $DIRSTACKFILE ] && [ $#dirstack -eq 0 ]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [ -d $dirstack[1] ] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

# Remember visited directories [END]

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# This reverts the +/- operators.
setopt pushdminus

# Maintain coloured output when piping [START]:
zmodload zsh/zpty

pty() {
	zpty pty-${UID} ${1+$@}
	if [[ ! -t 1 ]];then
		setopt local_traps
		trap '' INT
	fi
	zpty -r pty-${UID}
	zpty -d pty-${UID}
}

ptyless() {
	pty $@ | less
}
# Maintain coloured output when piping [END]:

# Use vi bindings:
bindkey -v

# vim arrow search/nav
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Use vim keys in tab complete menu:
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# ci"
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, di{ etc..
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# VTE fix:
if [ -f /etc/profile.d/vte.sh ]; then
  . /etc/profile.d/vte.sh
fi

# Include Ruby Gems in search path:
if [ -x "$(command -v ruby)" ]; then
  PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
  export GEM_HOME=$HOME/.gem
fi

if [ -d "$HOME/.fzf/shell" ]; then
  source ~/.fzf/shell/completion.zsh
  source ~/.fzf/shell/key-bindings.zsh
fi

# Go to directory via `fzf` and `fd`
bindkey -s '^g' 'cdfzf'

# Work config:
if [ -f $HOME/code/work/bpk-aws ]; then
  source $HOME/code/work/bpk-aws
fi

eval "$(starship init zsh)"
