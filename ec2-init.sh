#!/bin/bash

# Initialize a new EC2 instance.  (Generate a bash config, etc.)

# Define functions, constants, default args:
usage() { echo "usage: $0 [-h|--help] [-i|--ignore-errors]"; }
BASH_CONFIG_FILE="$PWD"/.bashrc
ignore_errors=0


# Deal with the command line:
#############################

# Run getopt:
options=$(getopt -l "help,ignore-errors" -o "hi" -- "$@")
[ $? -eq 0 ] || { echo "error parsing options"; exit -1; }
echo "$options"
eval set -- "$options"

# Walk through the options:
while true ; do
    case "$1" in
	-h|--help)
	    usage
	    exit 0
	    ;;
	-i|--ignore-errors)
	    ignore_errors=1
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
[ $# -eq 0 ] || { echo "error: unrecognized argument: $1"; usage; exit -2; }


# Generate a bash config:
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

# Bail out if a bash config already exists and we're not ignoring errors.
if [[ -f $BASH_CONFIG_FILE && $ignore_errors -eq 0 ]] ; then
    echo "error: $BASH_CONFIG_FILE already exists"
    exit -3
fi


# Otherwise, don't bail out if we're ignoring errors, but still never
#   overwrite an existing bash config.
if [[ $ignore_errors -eq 1 && -f $BASH_CONFIG_FILE ]] ; then
    echo "$BASH_CONFIG_FILE already exists; skipping"
else

    echo "Generating $BASH_CONFIG_FILE..."
    echo "$BASH_CONFIG" > $BASH_CONFIG_FILE
fi


exit 0
