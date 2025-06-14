#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

source ~/.config/shell/base.sh

if [ -z "$BASH_EXECUTION_STRING" ]; then
  exec fish
fi
