#!/bin/bash

# Initialize a new EC2 instance.  (Generate a .bashrc, etc.)

# Define functions and contants:
usage() { echo "usage: $0 [-h|--help] [-f|--force]"; }
BASH_CONFIG_FILE="$PWD"/.bashrc


# Deal with the command line:
#############################

# Run getopt:
options=$(getopt -l "help" -o "h" -- "$@")
[ $? -eq 0 ] || { echo "error parsing options"; exit -1; }
eval set -- "$options"

# Walk through the options:
while true ; do
    case "$1" in
	-h|--help)
	    usage
	    exit 0
	    ;;
	--)
	    shift
	    break;;
	*)
	    echo "error parsing args"
	    exit -1
	    ;;
    esac
    shift
done
[ $# -eq 0 ] || { echo "error: unrecognized argument: $1"; exit -2; }


# Generate a .bashrc:
#####################

read -r -d '' BASH_CONFIG <<EOF
#!/bin/bash

#alias ls="ls --color=auto -F"
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

export EDITOR="emacs -nw"
export PATH=$HOME/.local/bin:$PATH

#PROMPT_COLOR="0;30m" # black
#PROMPT_COLOR="0;31m" # red
#PROMPT_COLOR="0;32m" # green
#PROMPT_COLOR="1;34m" # blue
#PROMPT_COLOR="0;35m" # purple
#PROMPT_COLOR="0;36m" # light blue
PROMPT_COLOR="0;37m" # gray

export PS1="\[\033[${PROMPT_COLOR}\]\u@\h:\W\$ \[\033[00m\]"
#export PS1="\[\033[${PROMPT_COLOR}\]\u:\W\$ \[\033[00m\]"
#export PS1="\u@\h:\W\$ \[\033[00m\]"


EOF

# Bail out if a .bashrc already exists.  (I'm not including an option
#   to force deletion, because having a script delete ~/.bashrc creeps
#   me out.)
[ ! -f $BASH_CONFIG_FILE ] || \
    { echo "error: $BASH_CONFIG_FILE already exists"; exit -3; }

echo "$BASH_CONFIG" > $BASH_CONFIG_FILE



exit 0
