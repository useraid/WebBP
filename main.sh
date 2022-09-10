#!/bin/bash

# Banner

clear
cat << EOF

██╗    ██╗███████╗██████╗ ██████╗ ██████╗ 
██║    ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
██║ █╗ ██║█████╗  ██████╔╝██████╔╝██████╔╝
██║███╗██║██╔══╝  ██╔══██╗██╔══██╗██╔═══╝ 
╚███╔███╔╝███████╗██████╔╝██████╔╝██║     
 ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═════╝ ╚═╝  
                                -useraid


Welcome to WebBP.     

For options and flags use -h or --help.
EOF

# Help Function

function help {
cat <<EOF


This program generates a Boilerplate template for you web applications.
    WARNING: Some of the functionality in this program requires root privileges. Use at
your own risk.

    options:

        -h|--help                Display all options and flags. 


EOF
}

# Docker Installation Check

function docker {
  if ! command -v docker &> /dev/null
  then
      curl -fsSL https://get.docker.com -o docker.sh
      sh docker.sh
  fi
}

# Selection Flags

while getopts 'hr:' FLAG; do
  case "$FLAG" in
    h)
      help
      ;;
    r)
      rname="$OPTARG"
      echo "value $OPTARG"
      ;;
    \?)
      echo "usage: $(basename \$0) [-flag] *name for app* " >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
