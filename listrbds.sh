#!/bin/bash
#
# Get a detailed list of RBD images for all Pools
#
# Eugene Lezar
# CVS: $Header$

declare -rx script=${0##*/}
declare -rx rados="/usr/bin/rados"
declare -rx ls="/usr/bin/ls"
declare -rx timeout="/usr/bin/timeout"
declare -rx rbd="/usr/bin/rbd"

# Verify commands
if test ! -x "$rados" ; then
  printf "$script:$LINENO: Verify the $rados command, it is not available / executable - aborting\n" >&2
  exit 192
fi
if test ! -x "$ls" ; then
  printf "$script:$LINENO: Verify the $ls command, it is not available / executable - aborting\n" >&2
  exit 192
fi
if test ! -x "$timeout" ; then
  printf "$script:$LINENO: Verify the $timeout command, it is not available / executable - aborting\n" >&2
  exit 192
fi
if test ! -x "$rbd" ; then
  printf "$script:$LINENO: Verify the $rbd command, it is not available / executable - aborting\n" >&2
  exit 192
fi

# Set our output file and make sure we start clean
LOG=/var/log/rbdlist.log
if [ -f $LOG ]
  then
    rm $LOG
fi

# Read all Pools and list their images
for x in `rados lspools`;
        do echo 'POOL NAME:' $x >> $LOG;
	  $timeout 60 $rbd ls -l $x >> $LOG;
	  echo '======' >> $LOG;
        done

printf "List of RBD images for all Pools created in $LOG\n"

exit 0
