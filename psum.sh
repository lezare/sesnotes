#!/bin/bash
#
# Get only Pool information from Ceph-Report output
#
# Eugene Lezar
# CVS: $Header$

shopt -s -o nounset

declare -rx script=${0##*/}
declare -rx tput="/usr/bin/tput"
declare -rx grep="/usr/bin/grep"

# Verify Commands and input file parameter
if [ ! -x "$tput" ] ; then
	printf "$script:$LINENO: The $tput command is not available - aborting\n" >&2
	exit 192
fi
if [ ! -x "$grep" ] ; then 
	printf "$grep:$LINENO: The $grep command is not available - aborting\n" >&2
	exit 192
fi
if [[ $# -ne 1 ]] ; then
	printf "Required file parameter not specified, please specify an input file\n" >&2
	exit 192
fi

# Setting output colours using tput
RED=`$tput setaf 1`
GREEN=`$tput setaf 2`
RESET=`$tput sgr0`

# Set Output File and make sure we start clean
LOG=pool_summary.log

if [ -f $LOG ] ; then
	rm $LOG
fi

# Get the Pool info
$grep -E '(^ {16}"pool_name":)|(^ {16}"pool":)|(^ {16}"type":)|(^ {16}"size":)|(^ {16}"min_size":)|(^ {16}"crush_rule":)|(^ {16}"pg_num":)|(^ {16}"pg_placement_num":)|(^ {16}"erasure_code_profile":)' $1 >> $LOG

printf "#################\n"
printf "#### Written pool information summary for the cluster to ${RED}$LOG${RESET} ####\n"
printf "#################\n"
