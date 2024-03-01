#!/bin/bash

# Initialize a new EC2 instance.  (Generate a .bashrc, etc.)

# Define functions and contants:
usage() { echo "usage: $0 [-h|--help] [-f|--force]"; }
BASHRC_FILE="$PWD"/.bashrc


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

read -r -d '' BASHRC <<EOF
#!/bin/bash

EOF

# Bail out if a .bashrc already exists.  (I'm not including an option
#   to force deletion; having a script delete ~/.bashrc creeps me
#   out.)
[ ! -f $BASHRC_FILE ] || { echo "error: $BASHRC_FILE already exists"; exit -3; }

echo "$BASHRC" > $BASHRC_FILE



exit 0
