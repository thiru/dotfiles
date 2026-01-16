#
# Bash config for interactive shells
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Only load shell-agnostic config if not already loaded
if [[ "${MY_PROFILE_LOADED}" != "true" ]]; then
  source ~/.profile
fi

if [ -z "$BASH_EXECUTION_STRING" ]; then
  exec fish
fi
