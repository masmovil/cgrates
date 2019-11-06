#! /usr/bin/env sh


user=$1
if [ -z "$1" ]; then
	user="cgrates"
fi

host=$2
if [ -z "$2" ]; then
	host="localhost"
fi

database=$3
if [ -z "$3" ]; then
	database="cgrates"
fi

DIR="$(dirname "$(readlink -f "$0")")"

psql -U $user -h $host -d $database -f "$DIR"/create_cdrs_tables.sql
cdrt=$?
psql -U $user -h $host -d $database -f "$DIR"/create_tariffplan_tables.sql
tpt=$?

if [ $cdrt = 0 ] && [ $tpt = 0 ]; then
	echo "\n\t+++ CGR-DB successfully set-up! +++\n"
	exit 0
fi


